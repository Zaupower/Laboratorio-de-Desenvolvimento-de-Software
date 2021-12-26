namespace CentralMusicAPI.Models.Exceptions
{
    public class SuccessExceptionModel
    {
        public SuccessExceptionModel(string message)
        {
            this.Success = message;
        }
        public string Success { get; init; }
    }

}