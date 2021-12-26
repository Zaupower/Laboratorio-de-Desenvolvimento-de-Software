using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CentralMusicAPI.Helpers
{
    public class WriteHelper
    {
        public enum ImageFormat
        {
            bmp,
            jpeg,
            gif,
            tiff,
            png,
            unknown
        };

        internal static ImageFormat GetImageFormat(byte[] fileBytes)
        {
            var bmp = Encoding.ASCII.GetBytes("BM");
            var gif = Encoding.ASCII.GetBytes("GIF");
            var png = new byte[] { 137, 80, 71 }; //header bytes
            var tiff = new byte[] { 73, 73, 42 }; //header bytes
            var tiff2 = new byte[] { 77, 77, 42 }; //header bytes
            var jpeg = new byte[] { 255, 216, 255, 224 }; //header bytes
            var jpeg2 = new byte[] { 255, 216, 255, 225 }; //header bytes

            if (bmp.SequenceEqual(fileBytes.Take(bmp.Length)))         
                return ImageFormat.bmp;
            
            if (gif.SequenceEqual(fileBytes.Take(gif.Length)))            
                return ImageFormat.gif;           
            if (png.SequenceEqual(fileBytes.Take(png.Length)))            
                return ImageFormat.png;
            if (tiff.SequenceEqual(fileBytes.Take(tiff.Length)))
                return ImageFormat.tiff;
            if (tiff2.SequenceEqual(fileBytes.Take(tiff2.Length)))
                return ImageFormat.tiff;
            if (jpeg.SequenceEqual(fileBytes.Take(jpeg.Length)))
                return ImageFormat.jpeg;
            if (jpeg2.SequenceEqual(fileBytes.Take(jpeg2.Length)))
                return ImageFormat.jpeg;

            return ImageFormat.unknown;
        }
    }
}
