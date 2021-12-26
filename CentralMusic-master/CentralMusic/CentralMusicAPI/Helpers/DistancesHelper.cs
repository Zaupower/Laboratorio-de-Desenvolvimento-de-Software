using System;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Xml.Linq;

namespace CentralMusicAPI.Helpers
{
    /// <summary>
    /// Helper Funciton para facilitar o uso de endereços e coordenadas para o calculo de distancia entre dois pontos
    /// </summary>
    public class DistancesHelper
    {
        /// <summary>
        /// Método para calcular as distancia entre dois endereços utilizando a API da Google - Distance Matrix API
        /// </summary>
        /// <param name="origin"></param>
        /// <param name="destination"></param>
        /// <returns>Distancia entre os dois pontos</returns>
        public static int? calculateDistanceBetweenAddresses(string origin, string destination)
        {

            int distance = 0;
            string url = "https://maps.googleapis.com/maps/api/distancematrix/xml?origins=" + origin + "&destinations=" + destination + "&key=AIzaSyDEzgAjkVoUEErEH6bOMsTMX0Bn8lt0dQ0";
            WebRequest request = WebRequest.Create(url);
            using (WebResponse response = (HttpWebResponse)request.GetResponse())
            {
                using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
                {
                    try
                    {
                        DataSet dsResult = new DataSet();
                        dsResult.ReadXml(reader);
                        distance = int.Parse(dsResult.Tables["distance"].Rows[0]["value"].ToString()) / 1000;
                    }
                    catch (NullReferenceException)
                    {
                        return null;
                    }
                }

            }

            return distance;
        }

        /// <summary>
        /// Método para obter o endereço através de coordenadas GPS
        /// </summary>
        /// <param name="latitude"></param>
        /// <param name="longitude"></param>
        /// <returns>Endereço relacionado com as coordenadas</returns>
        public static string getAddressFromCoordinates(string latitude, string longitude)
        {
            string locationName = "";
            string url = string.Format("https://maps.googleapis.com/maps/api/geocode/xml?latlng={0},{1}&sensor=false&key=AIzaSyDMgV_g_vtWmPwttYWXM8IEU13o-77bSQA", latitude, longitude);
            XElement xml = XElement.Load(url);
            if (xml.Element("status").Value == "OK")
            {
                locationName = string.Format("{0}",
                    xml.Element("result").Element("formatted_address").Value);
                return locationName;
            }
            else
            {
                throw new Exception("Localização Não Encontrada!");
            }

        }
    }
}
