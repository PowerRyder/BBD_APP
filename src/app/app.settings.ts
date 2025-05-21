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

    public static readonly IsTestNetworkEnabled = false;
    public static readonly ContractAddress = this.IsTestNetworkEnabled ? '0x1D861F3F4e48C24981f171242419Cc59512fC9E4' : '0x2F2B5AB7E553a421BfF9A29f024B8586657c22A8';  //0xF9aF94304fc7A1aadB3c40f0e7840455a756D60c
    public static readonly ABI: any = abi;

    public static readonly IsPaymentCurrencyDifferentThanNative = true;

    static CHAIN = this.IsTestNetworkEnabled ? Chain.BEP20.TestNet : Chain.BEP20.MainNet;

    public static readonly PaymentTokenSymbol = this.IsPaymentCurrencyDifferentThanNative ? "USDT" : this.CHAIN.NativeCurrency.Symbol;
    public static readonly PaymentTokenContractAddress = this.IsTestNetworkEnabled ? '0x4622B46df102fD8648385bc96fd7a837111AeC61' : '0x541Db716243C6168911e1F406f520Ce67C0d4725';
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
