using System.Collections.Generic;
using System.IO;
using System.Text;

namespace RMXPx.Scripting
{
    public static class XapInspector
    {
        public static IList<string> GetFileNames(Stream stream)
        {
            var ret = new List<string>();
            var archiveStream = new BinaryReader(stream);

            while (true)
            {
                string file = GetFileName(archiveStream);
                if (file == null) break;
                ret.Add(file);
            }

            return ret;
        }

        private static string GetFileName(BinaryReader reader)
        {
            // Info from http://www.pkware.com/documents/casestudies/APPNOTE.TXT
            var headerSignature = reader.ReadInt32();  // local file header signature     4 bytes  (0x04034b50)
            if (headerSignature != 0x04034b50)
                return null; // Not a local file header
            reader.ReadInt16();                        // version needed to extract       2 bytes
            reader.ReadInt16();                        // general purpose bit flag        2 bytes
            reader.ReadInt16();                        // compression method              2 bytes
            reader.ReadInt16();                        // last mod file time              2 bytes
            reader.ReadInt16();                        // last mod file date              2 bytes
            reader.ReadInt32();                        // crc-32                          4 bytes 
            var compressedsize = reader.ReadInt32();   // compressed size                 4 bytes
            reader.ReadInt32();                        // uncompressed size               4 bytes
            var filenamelength = reader.ReadInt16();   // file name length                2 bytes
            var extrafieldlength = reader.ReadInt16(); // extra field length              2 bytes
            var fn = reader.ReadBytes(filenamelength); // file name                    (variable size)
            var filename = UTF8Encoding.UTF8.GetString(fn, 0, filenamelength);
            reader.ReadBytes(extrafieldlength);        // extra field                  (variable size)
            reader.ReadBytes(compressedsize);          // compressed data              (variable size)

            return filename;
        }
    }
}