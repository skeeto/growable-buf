# Growable Memory Buffers for C99

This C99 header library provides a simple, portable interface to
growable buffers of homogenous values of any type, similar to a
std::vector in C++. The user need not use any particular struct, and the
buffer need only initialize to NULL.

Each "function" in the interface is actually a macro, and its usage is
reflected by these hypothetical prototypes:

```c
/* Returns the number of elements in the buffer (for push and pop).
*/
size_t buf_size(type v);

/* Returns the total capacity of the buffer.
*/
size_t buf_capacity(type v);

/* Destroy and free the buffer, effectively resetting it.
 * Potentially assigns a new V pointer.
*/
void buf_free(type v);

/* Append an element E to the end of the buffer, growing if necessary.
 * Potentially increases the capacity and assigns a new V pointer.
*/
void buf_push(type v, e);

/* Remove an element E from the end of the buffer.
 * Neither the capacity nor the V pointer will change. Popping when the
 * size is zero has undefined results.
 */
type buf_pop(type v, e);

/* Increase buffer capactity by N elements.
 * Potentially assigns a new V pointer while also returning it.
 */
tyoe *buf_grow(type v, intptr_t n)

/* Set buffer capactity to exactly N elements.
 * Potentially assigns a new V pointer while also returning it. A
 * negative capacity has undefined results.
 */
type *buf_trunc(type v, intptr_t n);
```

Note: `buf_push()`, `buf_grow()`, `buf_trunc()`, and `buf_free()` may
change the buffer pointer, and any previously-taken pointers should be
considered invalidated. This has important consequences that must be
considered.

The `BUF_INIT_CAPACITY` determines the initial capacity for buffers
recieving their first push.

The `BUF_ABORT` macro is evaluated when the system runs out of memory.
It defaults to `abort()`, but you may override it to run your own abort
code instead.

Example usage:

```c
float *values = 0;

/* Append 25 values */
for (size_t i = 0; i < 25; i++)
    buf_push(values, rand() / (float)RAND_MAX);

/* Access 25 values using the normal [] operator */
for (size_t i = 0; i < buf_size(values); i++)
    printf("values[%zu] = %f\n", i, values[i]);

/* Destroy/reset the buffer */
buf_free(values);
```

## Purpose

This library is inspired by [stb `stretchy_buffer.h`][sb]. The
difference is that it's written in C99 so that it doesn't need to rely
on undefined behavior. This does so by using a flexible array member and
the `offsetof()` macro. It also checks for integer overflows before
allocating any memory, making it safer.


[sb]: https://github.com/nothings/stb/blob/master/stretchy_buffer.h
