import { dashboardTilesAppearance } from "./misc/app.custom-type";
import * as _urls from './json/routes.json';
import { abi } from './misc/abi';
import * as Chains from './json/chains.json';
import { paymentTokenAbi } from './misc/payment-token-abi';

export let app_routes = _urls;
let Chain = Chains;

export class AppSettings {
    private static readonly IsDevelopment = true;

    public static readonly IsDemo = true;
    
    public static readonly CompanyName = "Neuradigi DApp Demo";
    public static readonly Logo = "https://neuradigi.com/assets/img/logo.png";
    public static readonly Website = "https://dapp.neuradigi.com/"

    public static readonly IsInternalToken = true;
    public static readonly InternalTokenName = "Neuradigi";

    public static readonly IsTestNetworkEnabled = true;
    public static readonly ContractAddress = this.IsTestNetworkEnabled ? '0xDEDE1176d4c72b4C9E043B6A4BAF122D1a4D68a3' : '0x2DD1788E21E89728bD997f4d7Aa8c24e4591bC8B';
    public static readonly ABI: any = abi;

    public static readonly IsPaymentCurrencyDifferentThanNative = true;

    static CHAIN = this.IsTestNetworkEnabled ? Chain.BEP20.TestNet : Chain.BEP20.MainNet;

    public static readonly PaymentTokenSymbol = this.IsPaymentCurrencyDifferentThanNative ? "TEST" : this.CHAIN.NativeCurrency.Symbol;
    public static readonly PaymentTokenContractAddress = this.IsTestNetworkEnabled ? '0xc06e70c4038059965172Cf02025d7e5033f39767' : '0x570A5D26f7765Ecb712C0924E4De545B89fD43dF';
    public static readonly PaymentTokenABI: any = paymentTokenAbi;
    public static readonly PaymentTokenDecimals = 18;

    public static readonly ZeroAddress = "0x0000000000000000000000000000000000000000";

    public static readonly AdminAddress = "0x1419AC3544770Ac32fbC3e70129E7eb0197612F6";

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
