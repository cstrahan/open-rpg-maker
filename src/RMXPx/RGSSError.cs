using System;
using IronRuby.Runtime;

namespace RMXPx
{
    [RubyException("RGSSError")]
    public class RGSSError : Exception
    {
        public RGSSError()
        {
        }

        public RGSSError(string message) : base(message)
        {
        }
        
        public RGSSError(string message, Exception innerException) : base(message, innerException)
        {
        }
    }
}