namespace CentralMusicAPI.Models.Exceptions
{
    public class ErrorExceptionModel
    {
        public ErrorExceptionModel(string error)
        {
            this.Error = error;
        }

        public string Error { get; init; }
    }

}
