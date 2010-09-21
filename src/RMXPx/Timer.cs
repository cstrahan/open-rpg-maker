using System.Threading;
using System.Windows.Threading;

namespace RMXPx
{
    public class Timer
    {
        public int FrameDelay { get; private set; }

        private int _count;
        private readonly Thread _thread;
        private readonly object _syncRoot = new object();

        public Timer(int milliseconds)
        {
            FrameDelay = milliseconds;

            _thread = new Thread(Process);
            _thread.Start();
        }

        private void Process()
        {
            while (true)
            {
                Thread.Sleep(FrameDelay);
                Interlocked.Increment(ref _count);
            }
        }

        public void FrameReset()
        {
            Interlocked.Exchange(ref _count, 0);
        }

        public void Wait()
        {
            while (true)
            {
                lock(_syncRoot)
                {
                    if (_count > 0)
                    {
                        Interlocked.Decrement(ref _count);
                        return;
                    }
                }

                Thread.Sleep(1);
            }
        }
    }
}