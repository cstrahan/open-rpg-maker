using System;
using System.Collections.Generic;

namespace RMXPx
{
    public static class Extensions
    {
        public static IEnumerable<TResult> Zip<TFirst, TSecond, TResult>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second, Func<TFirst, TSecond, TResult> func)
        {
            if (first == null)
                throw new ArgumentNullException("first");
            if (second == null)
                throw new ArgumentNullException("second");
            if (func == null)
                throw new ArgumentNullException("func");
            using (var ie1 = first.GetEnumerator())
            using (var ie2 = second.GetEnumerator())
                while (ie1.MoveNext() && ie2.MoveNext())
                    yield return func(ie1.Current, ie2.Current);
        }
    }
}