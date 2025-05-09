
export class RegexPatterns{
    public static readonly digitsOnly = /^\d+$/;
    public static readonly personName = /^[a-zA-Z]+[a-zA-Z.\s]*$/;
    public static readonly ifsc = /^[a-zA-Z0-9]{11}$/;
    public static readonly panCardNumber = /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
    public static readonly upiId = /^[a-zA-Z0-9.\-_]{2,49}@[a-zA-Z._]{2,49}$/
}
