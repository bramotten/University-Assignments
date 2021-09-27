
/* Do not edit this function, as it used in testing too
 * Add you own hash functions with different headers instead. */
unsigned long hash_too_simple(unsigned char *str) {
    return (unsigned long)*str;
}

/* D. J. Bernstein's hash function,
 * http://www.cse.yorku.ca/~oz/hash.html */
unsigned long the_best_hash(unsigned char *str) {
    unsigned long hash = 5381;
    unsigned long c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}
