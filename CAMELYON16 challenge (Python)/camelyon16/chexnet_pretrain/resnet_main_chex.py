# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
"""Train a ResNet-50 model on ImageNet on TPU."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import time

import absl.logging as _logging  # pylint: disable=unused-import
import tensorflow as tf

import chexnet_input
import resnet_model_512 as resnet_model
from tensorflow.contrib import summary
from tensorflow.contrib.tpu.python.tpu import tpu_config
from tensorflow.contrib.tpu.python.tpu import tpu_estimator
from tensorflow.contrib.tpu.python.tpu import tpu_optimizer
from tensorflow.python.estimator import estimator
from tensorflow.python.framework import ops

import horovod.tensorflow as hvd
import os

import sys
cur_folder = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sep = '/'  # \\ on Windows
parent_folder = cur_folder[:cur_folder.rfind(sep)]
sys.path.append(parent_folder)
from camelyon16.utils import *

import camelyon16.preprocess.b3_tf_records as b3_tf_records

FLAGS = tf.flags.FLAGS

tf.flags.DEFINE_bool(
    'use_tpu', False,
    help=('Use TPU to execute the model for training and evaluation. If'
          ' --use_tpu=false, will use whatever devices are available to'
          ' TensorFlow by default (e.g. CPU and GPU)'))

# Cloud TPU Cluster Resolvers
tf.flags.DEFINE_string(
    'gcp_project', default=None,
    help='Project name for the Cloud TPU-enabled project. If not specified, we '
    'will attempt to automatically detect the GCE project from metadata.')

tf.flags.DEFINE_string(
    'tpu_zone', default=None,
    help='GCE zone where the Cloud TPU is located in. If not specified, we '
    'will attempt to automatically detect the GCE project from metadata.')

tf.flags.DEFINE_string(
    'tpu_name', default=None,
    help='Name of the Cloud TPU for Cluster Resolvers. You must specify either '
    'this flag or --master.')

tf.flags.DEFINE_string(
    'master', default=None,
    help='gRPC URL of the master (i.e. grpc://ip.address.of.tpu:8470). You '
    'must specify either this flag or --tpu_name.')

# Model specific flags
tf.flags.DEFINE_string(
    'data_dir', default='',#'/scratch/shared/camelyon16/bram/Processed/patch-based-classification/tf-records/',
    help=('The directory where the ImageNet input data is stored. Please see'
          ' the README.md for the expected data format.'))

tf.flags.DEFINE_string(
    'model_dir', default='',#'/scratch/shared/camelyon16/bram/resnet/'
    help=('The directory where the model and training/evaluation summaries are'
          ' stored.'))

tf.flags.DEFINE_string(
    'checkpoint_path', default='',#/scratch-shared/camelyon16-pretrain/model_512.ckpt-13583
    help=('The directory where the model and training/evaluation summaries are'
          ' stored.'))

tf.flags.DEFINE_integer(
    'resnet_depth', default=70,  # 70 (1024) / 72 (512) (or the other way around)
    help=('Depth of ResNet model to use. Must be one of {18, 34, 50, 101, 152,'
          ' 200}. ResNet-18 and 34 use the pre-activation residual blocks'
          ' without bottleneck layers. The other models use pre-activation'
          ' bottleneck layers. Deeper models require more training time and'
          ' more memory and may require reducing --train_batch_size to prevent'
          ' running out of memory.'))

tf.flags.DEFINE_integer('num_intra_threads', 1,
                        'Number of threads to use for intra-op parallelism. If '
                        'set to 0, the system will pick an appropriate number.')
tf.flags.DEFINE_integer('num_inter_threads', 0,
                        'Number of threads to use for inter-op parallelism. If '
                        'set to 0, the system will pick an appropriate number.')

tf.flags.DEFINE_boolean(
    'mkl', False, 'If true, set MKL environment variables.')
tf.flags.DEFINE_integer('kmp_blocktime', 30,
                        'The time, in milliseconds, that a thread should wait, '
                        'after completing the execution of a parallel region, '
                        'before sleeping')
tf.flags.DEFINE_string('kmp_affinity', 'granularity=fine,verbose,compact,1,0',
                       'Restricts execution of certain threads (virtual execution '
                       'units) to a subset of the physical processing units in a '
                       'multiprocessor computer.')
tf.flags.DEFINE_integer('kmp_settings', 1,
                        'If set to 1, MKL settings will be printed.')

tf.flags.DEFINE_integer(
    'train_steps', default=112603,
    help=('The number of steps to use for training. Default is 112603 steps'
          ' which is approximately 90 epochs at batch size 1024. This flag'
          ' should be adjusted according to the --train_batch_size flag.'))

tf.flags.DEFINE_integer(
    'train_batch_size', default=1024, help='Batch size for training.')

tf.flags.DEFINE_integer(
    'eval_batch_size', default=200, help='Batch size for evaluation.')

tf.flags.DEFINE_integer(
    'steps_per_eval', default=2405000,
    help=('Controls how often evaluation is performed. Since evaluation is'
          ' fairly expensive, it is advised to evaluate as infrequently as'
          ' possible (i.e. up to --train_steps, which evaluates the model only'
          ' after finishing the entire training regime).'))

tf.flags.DEFINE_integer(
    'iterations_per_loop', default=100,
    help=('Number of steps to run on TPU before outfeeding metrics to the CPU.'
          ' If the number of iterations in the loop would exceed the number of'
          ' train steps, the loop will exit before reaching'
          ' --iterations_per_loop. The larger this value is, the higher the'
          ' utilization on the TPU.'))

tf.flags.DEFINE_integer(
    'num_cores', default=8,
    help=('Number of TPU cores. For a single TPU device, this is 8 because each'
          ' TPU has 4 chips each with 2 cores.'))

tf.flags.DEFINE_string(
    'data_format',
    default='channels_last',
    help=('A flag to override the data format used in the model. The value '
          'is either channels_first or channels_last. To run the network on '
          'CPU or TPU, channels_last should be used.'))

tf.flags.DEFINE_string(
    'export_dir',
    default='',#'/scratch/shared/camelyon16/bram/resnet/',
    help=('The directory where the exported SavedModel will be stored.'))

# Dataset constants
LABEL_CLASSES = 2
_FILE_SHUFFLE_BUFFER = 300
_NUM_CHANNELS = 3


NUM_TRAIN_IMAGES = 288000
NUM_EVAL_IMAGES = 10000

# Learning hyperparameters
BASE_LEARNING_RATE = 0.1     # base LR when batch size = 256
MOMENTUM = 0.9
WEIGHT_DECAY = 5e-4
LR_SCHEDULE = [    # (multiplier, epoch to start) tuples
    (1.0, 5), (0.1, 30), (0.01, 60), (0.001, 80)
]

# classes = ['Cardiomegaly',
#     'Emphysema',
#     'Effussion',
#     'Hernia',
#     'Nodule',
#     'Pneumonia',
#     'Atelectasis',
#     'PT',
#     'Mass',
#     'Edema',
#     'Consolidation',
#     'Infiltration',
#     'Fibrosis',
#     'Pneumothorax']
classes = ['Alive', 'Dead']


def learning_rate_schedule(current_epoch):
    """Handles linear scaling rule, gradual warmup, and LR decay.

    The learning rate starts at 0, then it increases linearly per step.
    After 5 epochs we reach the base learning rate (scaled to account
      for batch size).
    After 30, 60 and 80 epochs the learning rate is divided by 10.
    After 90 epochs training stops and the LR is set to 0. This ensures
      that we train for exactly 90 epochs for reproducibility.

    Args:
      current_epoch: `Tensor` for current epoch.

    Returns:
      A scaled `Tensor` for current learning rate.
    """
    scaled_lr = BASE_LEARNING_RATE * (FLAGS.train_batch_size / 256.0)

    decay_rate = (scaled_lr * LR_SCHEDULE[0][0] *
                  current_epoch / LR_SCHEDULE[0][1])
    for mult, start_epoch in LR_SCHEDULE:
        decay_rate = tf.where(current_epoch < start_epoch,
                              decay_rate, scaled_lr * mult)
    return decay_rate


def gradual_warmup_then_dec(learning_rate, warmup_steps, end_learning_rate, global_step, steps, name=None):
    with ops.name_scope(name, "gradual_warmup_then_dec",
                        [learning_rate, warmup_steps, end_learning_rate, global_step, steps, name]) as name:

        def warmup_decay(learning_rate, global_step, warmup_steps, end_learning_rate):
            p = global_step / warmup_steps
            diff = tf.subtract(end_learning_rate, learning_rate)
            res = tf.add(learning_rate, tf.multiply(diff, p))
            return res

        if global_step is None:
            raise ValueError("global_step is required for warmup_decay.")

        learning_rate = ops.convert_to_tensor(
            learning_rate, name="learning_rate")
        end_learning_rate = ops.convert_to_tensor(
            end_learning_rate, name="end_learning_rate")
        dtype = learning_rate.dtype
        global_step = tf.cast(global_step, dtype)
        warmup_steps = tf.cast(warmup_steps, dtype)
        total_train_steps = steps

        lr = tf.cond(tf.less(global_step, warmup_steps),
                     lambda: warmup_decay(
                         learning_rate, global_step, warmup_steps, end_learning_rate),
                     lambda: tf.train.polynomial_decay(end_learning_rate, global_step-warmup_steps, steps-warmup_steps, 0, power=1))
        return lr


def resnet_model_fn(features, labels, mode, params):
    """The model_fn for ResNet to be used with TPUEstimator.

    Args:
      features: `Tensor` of batched images.
      labels: `Tensor` of labels for the data samples
      mode: one of `tf.estimator.ModeKeys.{TRAIN,EVAL}`
      params: `dict` of parameters passed to the model from the TPUEstimator,
          `params['batch_size']` is always provided and should be used as the
          effective batch size.

    Returns:
      A `TPUEstimatorSpec` for the model
      features: `Tensor` of batched images.
      labels: `Tensor` of labels for the data samples
      mode: one of `tf.estimator.ModeKeys.{TRAIN,EVAL}`
      params: `dict` of parameters passed to the model from the TPUEstimator,
          `params['batch_size']` is always provided and should be used as the
          effective batch size.

    Returns:
      A `TPUEstimatorSpec` for the model
    """
    if isinstance(features, dict):
        features = features['feature']

    # In most cases, the default data format NCHW instead of NHWC should be
    # used for a significant performance boost on GPU/TPU. NHWC should be used
    # only if the network needs to be run on CPU since the pooling operations
    # are only supported on NHWC.
    if FLAGS.data_format == 'channels_first':
        features = tf.transpose(features, [0, 3, 1, 2])

    network = resnet_model.resnet_v1(
        resnet_depth=FLAGS.resnet_depth,
        num_classes=LABEL_CLASSES,
        data_format=FLAGS.data_format)

    logits = network(
        inputs=features, is_training=(mode == tf.estimator.ModeKeys.TRAIN))

    exclude = ['dense/bias', 'dense/kernel', 'global_step']
    tf.train.init_from_checkpoint(FLAGS.checkpoint_path, {v.name.split(':')[
                                  0]: v for v in tf.contrib.framework.get_variables_to_restore(exclude=exclude)})  # variables_to_restore})
    #probs = tf.sigmoid(logits, name='probs')
    #predictions = tf.argmax(logits, axis=1)
    predictions = {
        'classes': tf.argmax(input=logits, axis=1),
        'probabilities': tf.nn.softmax(logits, name='softmax_tensor')
    }

    if mode == tf.estimator.ModeKeys.PREDICT:
        return tf.estimator.EstimatorSpec(mode=mode, predictions=predictions)

    one_hot_labels = tf.one_hot(labels, LABEL_CLASSES)
    #cross_entropy = tf.losses.sigmoid_cross_entropy(labels, logits)
    cross_entropy =  tf.losses.softmax_cross_entropy(onehot_labels=labels, logits=logits)
    loss = cross_entropy + WEIGHT_DECAY * tf.add_n(
        [tf.nn.l2_loss(v) for v in tf.trainable_variables()
         if 'batch_normalization' not in v.name])

    # create a tensor for logging loss
    tf.identity(cross_entropy, 'cross_entropy')
    tf.summary.scalar('cross_entropy', cross_entropy)

    # If necessary, in the model_fn, use params['batch_size'] instead the batch
    # size flags (--train_batch_size or --eval_batch_size).
    batch_size = params['batch_size']   # pylint: disable=unused-variable

    if mode == tf.estimator.ModeKeys.TRAIN:
        # Compute the current epoch and associated learning rate from global_step.
        global_step = tf.train.get_or_create_global_step()
        batches_per_epoch = NUM_TRAIN_IMAGES / FLAGS.train_batch_size
        current_epoch = (tf.cast(global_step, tf.float32) /
                         batches_per_epoch)

        learning_rate = gradual_warmup_then_dec(0.275, int(
            batches_per_epoch * 5), 1.6, global_step, FLAGS.train_steps, name="gradual_warmup_then_dec")
        learning_rate_previous = gradual_warmup_then_dec(0.275, int(
            batches_per_epoch * 5), 1.6,  global_step-1, FLAGS.train_steps, name="gradual_warmup_then_dec")

        momentum_corr = learning_rate/learning_rate_previous
        optimizer = tf.train.MomentumOptimizer(
            learning_rate=learning_rate, momentum=momentum_corr * MOMENTUM, use_nesterov=False)
        if FLAGS.use_tpu:
            # When using TPU, wrap the optimizer with CrossShardOptimizer which
            # handles synchronization details between different TPU cores. To the
            # user, this should look like regular synchronous training.
            optimizer = tpu_optimizer.CrossShardOptimizer(optimizer)

        optimizer = hvd.DistributedOptimizer(optimizer)

        # Batch normalization requires UPDATE_OPS to be added as a dependency to
        # the train operation.
        update_ops = tf.get_collection(tf.GraphKeys.UPDATE_OPS)
        with tf.control_dependencies(update_ops):
            train_op = optimizer.minimize(loss, global_step)

        # To log the loss, current learning rate, and epoch for Tensorboard, the
        # summary op needs to be run on the host CPU via host_call. host_call
        # expects [batch_size, ...] Tensors, thus reshape to introduce a batch
        # dimension. These Tensors are implicitly concatenated to
        # [params['batch_size']].
        gs_t = tf.reshape(global_step, [1])
        loss_t = tf.reshape(loss, [1])
        lr_t = tf.reshape(learning_rate, [1])
        ce_t = tf.reshape(current_epoch, [1])

        def host_call_fn(gs, loss, lr, ce):
            """Training host call. Creates scalar summaries for training metrics.

            This function is executed on the CPU and should not directly reference
            any Tensors in the rest of the `model_fn`. To pass Tensors from the model
            to the `metric_fn`, provide as part of the `host_call`. See
            https://www.tensorflow.org/api_docs/python/tf/contrib/tpu/TPUEstimatorSpec
            for more information.

            Arguments should match the list of `Tensor` objects passed as the second
            element in the tuple passed to `host_call`.

            Args:
              gs: `Tensor with shape `[batch]` for the global_step
              loss: `Tensor` with shape `[batch]` for the training loss.
              lr: `Tensor` with shape `[batch]` for the learning_rate.
              ce: `Tensor` with shape `[batch]` for the current_epoch.

            Returns:
              List of summary ops to run on the CPU host.
            """
            gs = gs[0]
            with summary.create_file_writer(FLAGS.model_dir if hvd.rank() == 0 else None).as_default():
                with summary.always_record_summaries():
                    summary.scalar('loss', tf.reduce_mean(loss), step=gs)
                    summary.scalar('learning_rate',
                                   tf.reduce_mean(lr), step=gs)
                    summary.scalar('current_epoch',
                                   tf.reduce_mean(ce), step=gs)

                    return summary.all_summary_ops()

        host_call = (host_call_fn, [gs_t, loss_t, lr_t, ce_t])

        eval_metrics = None
        if mode == tf.estimator.ModeKeys.EVAL:
            def metric_fn(labels, logits):
                """Evaluation metric function. Evaluates accuracy.

                This function is executed on the CPU and should not directly reference
                any Tensors in the rest of the `model_fn`. To pass Tensors from the model
                to the `metric_fn`, provide as part of the `eval_metrics`. See
                https://www.tensorflow.org/api_docs/python/tf/contrib/tpu/TPUEstimatorSpec
                for more information.

                Arguments should match the list of `Tensor` objects passed as the second
                element in the tuple passed to `eval_metrics`.

                Args:
                  labels: `Tensor` with shape `[batch, ]`.
                  logits: `Tensor` with shape `[batch, num_classes]`.

                Returns:
                  A dict of the metrics to return from evaluation.
                """
                accuracy = tf.metrics.accuracy(labels, logits)
                for i in range(14):
                    metrics.update(
                        {classes[i]: tf.metrics.auc(labels[:, i], probs[:, i])})
                return {
                    'Top-1 accuracy': accuracy,
                    'probabs': metrics,
                }

            eval_metrics = (metric_fn, [labels, logits])

        return tpu_estimator.TPUEstimatorSpec(
            mode=mode,
            loss=loss,
            predictions=predictions,
            train_op=train_op,
            host_call=host_call,
            eval_metrics=eval_metrics)


def main(unused_argv):
    if FLAGS.use_tpu:
        # Determine the gRPC URL of the TPU device to use
        if FLAGS.master is None and FLAGS.tpu_name is None:
            raise RuntimeError(
                'You must specify either --master or --tpu_name.')

        if FLAGS.master is not None:
            if FLAGS.tpu_name is not None:
                tf.logging.warn('Both --master and --tpu_name are set. Ignoring'
                                ' --tpu_name and using --master.')
            tpu_grpc_url = FLAGS.master
        else:
            tpu_cluster_resolver = (
                tf.contrib.cluster_resolver.TPUClusterResolver(
                    FLAGS.tpu_name,
                    zone=FLAGS.tpu_zone,
                    project=FLAGS.gcp_project))
            tpu_grpc_url = tpu_cluster_resolver.get_master()
    else:
        # URL is unused if running locally without TPU
        tpu_grpc_url = None

        hvd.init()
        os.environ['KMP_SETTINGS'] = str(FLAGS.kmp_settings)
        os.environ['KMP_AFFINITY'] = FLAGS.kmp_affinity
        os.environ['KMP_BLOCKTIME'] = str(1)
        if FLAGS.num_intra_threads > 0:
            os.environ['OMP_NUM_THREADS'] = str(FLAGS.num_intra_threads)

    model_dir = FLAGS.model_dir
    config = tpu_config.RunConfig(
        master=tpu_grpc_url,
        save_checkpoints_secs=200 if hvd.rank() == 0 else 0,
        save_summary_steps=100 if hvd.rank() == 0 else 0,
        tf_random_seed=4321+hvd.rank(),
        evaluation_master=tpu_grpc_url,
        model_dir=model_dir,
        session_config=tf.ConfigProto(
            allow_soft_placement=True, log_device_placement=False, intra_op_parallelism_threads=FLAGS.num_intra_threads, inter_op_parallelism_threads=FLAGS.num_inter_threads),
        tpu_config=tpu_config.TPUConfig(
            iterations_per_loop=FLAGS.iterations_per_loop if hvd.rank() == 0 else 10000000,
            num_shards=hvd.size()))

    resnet_classifier = tpu_estimator.TPUEstimator(
        use_tpu=FLAGS.use_tpu,
        model_fn=resnet_model_fn,
        config=config,
        train_batch_size=int(FLAGS.train_batch_size / hvd.size()),
        eval_batch_size=FLAGS.eval_batch_size)

    bcast_hook = hvd.BroadcastGlobalVariablesHook(0)

    # Input pipelines are slightly different (with regards to shuffling and
    # preprocessing) between training and evaluation.
    imagenet_train = chexnet_input.ImageNetInput(
        is_training=True,
        data_dir=FLAGS.data_dir)
    imagenet_eval = chexnet_input.ImageNetInput(
        is_training=False,
        data_dir=FLAGS.data_dir)

    current_step = estimator._load_global_step_from_checkpoint_dir(
        FLAGS.model_dir)  # pylint: disable=protected-access,line-too-long
    batches_per_epoch = NUM_TRAIN_IMAGES / FLAGS.train_batch_size
    tf.logging.info('Training for %d steps (%.2f epochs in total). Current'
                    ' step %d.' % (FLAGS.train_steps,
                                   FLAGS.train_steps / batches_per_epoch,
                                   current_step))
    start_timestamp = time.time()
    while current_step < FLAGS.train_steps:
        tensors_to_log = {
            'cross_entropy': 'cross_entropy',
            'train_accuracy': 'train_accuracy',
            'probs': 'probs'
        }

        # Train for up to steps_per_eval number of steps. At the end of training, a
        # checkpoint will be written to --model_dir.
        next_checkpoint = min(current_step + FLAGS.steps_per_eval,
                              FLAGS.train_steps)
        resnet_classifier.train(
            input_fn=imagenet_train.input_fn, max_steps=next_checkpoint, hooks=[bcast_hook])
        current_step = next_checkpoint

        elapsed_time = int(time.time() - start_timestamp)
        tf.logging.info('Finished training up to step %d. Elapsed seconds %d.' %
                        (current_step, elapsed_time))

    if FLAGS.export_dir is not None:
        # The guide to serve a exported TensorFlow model is at:
        #    https://www.tensorflow.org/serving/serving_basic
        tf.logging.info('Starting to export model.')
        resnet_classifier.export_savedmodel(
            export_dir_base=FLAGS.export_dir,
            serving_input_receiver_fn=imagenet_input.image_serving_input_fn)


if __name__ == '__main__':
    tf.logging.set_verbosity(tf.logging.INFO)
    tf.app.run()
