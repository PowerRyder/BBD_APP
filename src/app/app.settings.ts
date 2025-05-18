import { dashboardTilesAppearance } from "./misc/app.custom-type";
import * as _urls from './json/routes.json';
import { abi } from './misc/abi';
import * as Chains from './json/chains.json';
import { paymentTokenAbi } from './misc/payment-token-abi';

export let app_routes = _urls;
let Chain = Chains;

export class AppSettings {
    private static readonly IsDevelopment = false;

    public static readonly IsDemo = false;
    
    public static readonly CompanyName = "BBD";
    public static readonly Logo = "assets/images/logo.png";
    public static readonly Website = "https://app.bbdweb3.com/"

    public static readonly IsInternalToken = false;
    public static readonly InternalTokenName = "Neuradigi";

    public static readonly IsTestNetworkEnabled = true;
    public static readonly ContractAddress = this.IsTestNetworkEnabled ? '0x4D5D771aD3e46AE13d2eA02dBe6c6924BaF47A46' : '0x2DD1788E21E89728bD997f4d7Aa8c24e4591bC8B';  //0xF9aF94304fc7A1aadB3c40f0e7840455a756D60c
    public static readonly ABI: any = abi;

    public static readonly IsPaymentCurrencyDifferentThanNative = true;

    static CHAIN = this.IsTestNetworkEnabled ? Chain.BEP20.TestNet : Chain.BEP20.MainNet;

    public static readonly PaymentTokenSymbol = this.IsPaymentCurrencyDifferentThanNative ? "USDT" : this.CHAIN.NativeCurrency.Symbol;
    public static readonly PaymentTokenContractAddress = this.IsTestNetworkEnabled ? '0x4622B46df102fD8648385bc96fd7a837111AeC61' : '0x570A5D26f7765Ecb712C0924E4De545B89fD43dF';
    public static readonly PaymentTokenABI: any = paymentTokenAbi;
    public static readonly PaymentTokenDecimals = 18;

    public static readonly ZeroAddress = "0x0000000000000000000000000000000000000000";

    public static readonly AdminAddress = "0xA1bF05780C2De3002086695D212a743EAA6532Ad";

    public static readonly ApiBaseUrl = this.IsDevelopment ? 'http://localhost:8000/' : '';

    public static readonly currencySymbol = "$";
    public static readonly isCurrencySymbolPrefixed = true;

    public static readonly matFormFieldAppearance: "fill" | "outline" = "outline";
    public static readonly matFormFieldHideRequiredMarker = false;

    public static readonly matTabGroupAnimationDisabled = false;
    public static readonly dashboardTilesAppearance: dashboardTilesAppearance = 'One-Row'

    
    public static readonly matPaginatorShowFirstLastButtons = true;
    public static readonly pageDefaultSize = 10;
    public static readonly pageSizeOptions = [10, 25, 50];

}
