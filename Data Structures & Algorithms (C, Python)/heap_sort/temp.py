# Trying to get a different Viterbi working, when it does replace the above


def viterbi(sentence, hmm):
    """
    Computes the best possible tag sequence for a given input
    and also returns it log probability.

    This implementation does NOT use recursion.

    :returns: tag sequence, log probability
    """
    sentence = hmm.preprocess_sentence(sentence, bos=False, eos=True)
    n = len(sentence)
    tagset = list(hmm.tagset())
    t = len(tagset)

    return ["TODO"], .42