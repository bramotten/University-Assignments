
/* Example hash function with terrible performance */
unsigned long hash_too_simple(unsigned char *str);

/* Add the header for your own added hash functions here. You may search online
 * for existing solutions for hashing function, as long as you as you
 * \emph{attribute the source}, meaning links to the used material. */

/* D. J. Bernstein's hash function,
 * http://www.cse.yorku.ca/~oz/hash.html */
unsigned long the_best_hash(unsigned char *str);
