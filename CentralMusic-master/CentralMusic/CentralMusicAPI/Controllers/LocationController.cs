using CentralMusicAPI.Helpers;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Globalization;

namespace CentralMusicAPI.Controllers
{
    /// <summary>
    /// Controler para obter o Endereço através das coordenadas GPS
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class LocationController : Controller
    {
        /// <summary>
        /// Rota para obter o endereço através de coordenadas GPS
        /// </summary>
        /// <param name="lat">Latitude</param>
        /// <param name="lng">Longitude</param>
        /// <remarks>
        /// Sample request:
        /// 
        ///     GET /location?lat=41.341068&amp;lng=-8.150010
        /// 
        /// </remarks>
        /// <returns>Endereço ou Exception</returns>
        /// <response code="200">Retorna o Endereço relacionado com as coordenadas</response>
        /// <response code="422">Unprocessable Entity</response>
        [HttpGet]
        public IActionResult GetLocation(double lat, double lng)
        {
            try
            {
                string address = DistancesHelper.getAddressFromCoordinates(lat.ToString(new CultureInfo("en-US")), lng.ToString(new CultureInfo("en-US")));
                return Ok(new { address });
            }
            catch (Exception ex)
            {
                return UnprocessableEntity(ex.Message);
            }

        }
    }
}
