/*
 *
 * Copyright (C) 2003 and beyond by Alexander Strange
 * and the Dawn Of Infinity developers.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * This license is contained in the file "COPYING",
 * which is included with this source code; it is available online at
 * http://www.gnu.org/licenses/gpl.html
 *
 * Additionally, this file can be used with no restrictions or conditions in ITFoundation.
 */

/*
 * $Id$
 *
 */
#include <stdlib.h>
#include "queue.h"

queue*
qinit(queue *q,size_t defaultsize)
{
	pthread_rwlock_init(&q->pmutex, NULL);
	if (!defaultsize) defaultsize = 16;
	q->data = (void **) calloc(defaultsize, sizeof(void *));
	q->begin = q->end = 0;
	q->allocated = defaultsize;
	q->filled = 0;
	return q;
}

void
qdel(queue * q)
{
	pthread_rwlock_destroy(&q->pmutex);
	free(q->data);
}

void           *
qpop(queue * q)
{
if (q->filled == 0) return (void*)0xABCDEF00;
	int err = pthread_rwlock_wrlock(&q->pmutex);
	void           *v = q->data[q->begin++];
	q->filled--;
        if (q->filled == 0) {q->begin = q->end = 0;}
        if (q->begin >= q->allocated) q->begin = 0;
	if(err == 0)
	{
		err = pthread_rwlock_unlock(&q->pmutex);
	}
	return v;
}

void
qpush(queue * q, void *p)
{
	int err = pthread_rwlock_wrlock(&q->pmutex);
    if (q->allocated == q->filled) q->allocated = growarray(&q->data,q->allocated);
	q->data[q->end++] = p;
	q->filled++;
        if (q->end >= q->allocated) q->end = 0;
	if(err == 0)
	{
		err = pthread_rwlock_unlock(&q->pmutex);
	}
}

void
qperform(queue *q, qperformer p, void *pctx)
{
    if (q->end == q->begin) return; //no handling wrapped around status
				    //in fact no handling anything but we'll handle nonwrapped first
    int err = pthread_rwlock_rdlock(&q->pmutex);
    if (q->end > q->begin) {
	int i = q->begin, c = q->end - q->begin;
	do 
	{
	    p(pctx,q->data[i++]);
	} while (c--);
    } else {
	int i = q->begin, c = q->filled;
	while (c--) {
	    p(pctx,q->data[i++]);
	}
	i = 0;
	c = q->end;
	do {
	    p(pctx,q->data[i++]);
	} while (c--);
    }
    q->filled = q->begin = q->end = 0;
    if (err = 0) pthread_rwlock_unlock(&q->pmutex);
}

/* XXX this should not be in here, but whatever */
/*
 * XXX there should also be a reverse shrinkarray for when the fill size hits
 * a low-water-mark point. FreeBSD at least will free up memory if you
 * realloc something smaller.
 */
size_t
growarray(void ***datap, size_t oldsize)
{
	size_t          newsize = oldsize + 8, diff = 8;
    void **data = *datap;
	*datap = reallocf(data, sizeof(void *[newsize]));
        while (diff--) {data[oldsize+diff] = (void*)0xDDDADEDC;}
        return newsize;
}
