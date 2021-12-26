using CentralMusicAPI.Entities;
using CentralMusicAPI.Entities.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CentralMusicAPI.Models
{
    public class PuplicationCreate
    {
        public int UtilizadorId { get; set; }
        public String Tittle { get; set; }
        public String Description { get; set; }
        public bool Tradable { get; set; }
        public Categories Category { get; set; }
        public int ImagePath { get; set; }
        public double InitialPrice { get; set; }
        public Condition InstrumentCondition { get; set; }
        public Address UserAddress { get; set; }

    }
}
