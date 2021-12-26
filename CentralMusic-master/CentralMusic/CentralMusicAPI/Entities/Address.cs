namespace CentralMusicAPI.Entities
{
    public class Address
    {
        public string Street { get; set; }
        public int StreetNumber { get; set; }
        public string PostalCode { get; set; }
        public string District { get; set; }
        public string Country { get; set; }

        public override string ToString()
        {
            return "" + Street + "," + StreetNumber + "," + PostalCode + "," + District + "," + Country;
        }
    }
}
