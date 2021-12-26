using CentralMusicAPI.Entities;
using CentralMusicAPI.Entities.Enums;
using System;

namespace CentralMusicAPI.Models
{
    public class Publication
    {
        public int Id { get; set; }
        public int UtilizadorId { get; set; }
        public String Tittle { get; set; }
        public String Description { get; set; }
        public bool Tradable { get; set; }
        public Categories Category { get; set; }
        public double InitialPrice { get; set; }
        public int ImagePath { get; set; }
        public Condition InstrumentCondition { get; set; }
        public Address UserAddress { get; set; }
        public int Range { get; internal set; }

    }
}
