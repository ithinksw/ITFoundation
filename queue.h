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
 */

/*
 * $Id$
 *
 */
#pragma once only
#ifndef _QUEUE_H
#define _QUEUE_H
#include <pthread.h>
#include <sys/types.h>

typedef struct queue {
    void **data;
    size_t begin;
    size_t end;
    size_t allocated;
    size_t filled;
    pthread_rwlock_t pmutex;
} queue;

typedef void    (*qperformer) (void *context, void *p);

extern queue *qinit(queue *q,size_t defaultsize);
extern void qdel(queue *q);
extern void *qpop(queue *q);
extern void qpush(queue *q, void *p);
extern size_t growarray(void ***datap, size_t oldsize);
extern void qperform(queue *q, qperformer p, void *pctx);
#endif