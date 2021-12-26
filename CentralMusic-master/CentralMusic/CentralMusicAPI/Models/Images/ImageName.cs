using System.ComponentModel.DataAnnotations;

namespace CentralMusicAPI.Models
{
    public class ImageName
    {
        [Required]
        public string Name { get; set; }
    }
}
