//SPDX-License-Identifier: None
pragma solidity ^0.8.20;

interface IBEP20 
{
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface ISecurityFund {
    function TransferTokens(address token, address user, uint256 amount) external;
}

contract BBD
{
    uint256 public TotalUsers = 0;
    uint256 public TotalInvestment = 0;
    uint256 public TotalWithdrawn = 0;

    address public CreatorAddress = 0xA1bF05780C2De3002086695D212a743EAA6532Ad;
    address public CreatorAddress_2 = 0x4F6A1cfdF5E55Db0c2ff4575B0887fEa8a967088;
    address public ManagementFee = 0x985495C028f9B896de454eC448B53FBA6450DA40;
    address public MarketingAddress = 0x73D1AD5a474E1712d6Cbe18d56b7281AaF190347;
    address public SecurityFundContract = address(0);


    address constant USDTContractAddress = 0x541Db716243C6168911e1F406f520Ce67C0d4725; //0x570A5D26f7765Ecb712C0924E4De545B89fD43dF;

    uint256 LevelIncome_LevelCount = 0;
    uint256 TotalRanksCount = 0;

    bool IsLevelIncomePercentage = true;

    uint256 TotalNoOfPackages = 0;

    uint256 constant PaymentCurrencyDecimals = 18;

    // bool WithdrawalAfterPrincipleAmount = true;
    address deployer;

    uint256 WithdrawalWalletId = 1;
    uint256 BBDWalletId = 2;

    struct User 
    {
        uint256 Id;
        address Address;
        address SponsorAddress;
        uint256 JoiningTimestamp;
        uint256 Investment;
        uint256 TotalTeam;
        uint256 FirstActivationTimestamp;
        uint256 LastActivationTimestamp;
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
        uint256 Capping;
        uint256 IncomePaid;
    }

    struct UserIncome 
    {
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
        uint256 BBD_TokenBuyCount;
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
        bool HasRange;
        uint256 MinAmount;
        uint256 MaxAmount;
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
        // bool WithdrawalAfterPrincipleAmount;
    }

    struct UserDashboard
    {
        address SponsorAddress;
        uint256 Investment;
        uint256 DirectsCount;
        uint256 DirectsInvestment;
        uint256 TeamCount;
        uint256 TeamA_Business;
        uint256 TeamB_Business;
        uint256 TeamInvestment;
        uint256 NewRegistrationBonus;
        uint256 LevelIncome;
        uint256 ROIIncome;
        uint256 PendingROIIncome;
        uint256 RankIncome;
        uint256 TopmostSponsorsIncome;
        uint256 TotalIncome;
        uint256 Capping;
        uint256 AmountWithdrawn;
        uint256 WithdrawalWalletBalance;
        uint256 TopupWalletBalance;
        string RankName;
        uint256 Capping4X_QualificationEndTimestamp;
        bool IsCappingRemaining;
        bool IsQualifiedFor4X;
        bool IsFirstActivationDone;
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
        uint256 ReqTeamCount;
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
        uint256 ReqTeamCount;
        uint256 UserSelfInvestment;
        bool HasOneTimeSelfInvestment;
        uint256 UserTeamA_Business;
        uint256 UserTeamB_Business;
        uint256 UserTeamCount;
        uint256 RewardAmount;
        bool IsAchieved;
    }

    struct TopSponsors {
        address sponsor;
        uint256 directInvestment;
    }

    struct BBDPurchase {
        uint256 AmountSpent;
        uint256 BBDAmountReceived;
        uint256 Timestamp;
        uint256 WalletId;
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
    mapping(address => address) public map_TeamALegAddress;

    mapping(address => mapping(uint256 => BBDPurchase)) public map_BBDPurchaseHistory;

    address[] private userActivations;

    IBEP20 public BBDTokenContract;
    uint256 public BBDTokenRate = 10 * 1e18; // tokens per 1 USDT (18 decimals assumed) i.e. 10 BBD per 1 USDT

    uint256 public AmountCollectedForTopSponsors = 0;

    modifier onlyOwner() {
        require(IsOwner(), "You are not allowed!");
        _;
    }

    constructor()
    {
        deployer = msg.sender;
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
            HasRange: true,
            MinAmount: ConvertToBase(30),
            MaxAmount: ConvertToBase(3000)
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
            ReqTeamCount: 20,
            ReqTeamA_Business: ConvertToBase(1000),
            ReqTeamB_Business: ConvertToBase(1000),
            RewardAmount: ConvertToBase(0)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "2 Star",
            ReqSelfInvestment: ConvertToBase(500),
            ReqTeamCount: 50,
            ReqTeamA_Business: ConvertToBase(5000),
            ReqTeamB_Business: ConvertToBase(5000),
            RewardAmount: ConvertToBase(0)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "3 Star",
            ReqTeamCount: 100,
            ReqSelfInvestment: ConvertToBase(1000),
            ReqTeamA_Business: ConvertToBase(10000),
            ReqTeamB_Business: ConvertToBase(10000),
            RewardAmount: ConvertToBase(0)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "4 Star",
            ReqTeamCount: 200,
            ReqSelfInvestment: ConvertToBase(2000),
            ReqTeamA_Business: ConvertToBase(25000),
            ReqTeamB_Business: ConvertToBase(25000),
            RewardAmount: ConvertToBase(2500)
        });
        
        TotalRanksCount++;
        map_RankMaster[TotalRanksCount] = RankMaster({
            RankId: TotalRanksCount,
            RankName: "5 Star",
            ReqTeamCount: 500,
            ReqSelfInvestment: ConvertToBase(3000),
            ReqTeamA_Business: ConvertToBase(75000),
            ReqTeamB_Business: ConvertToBase(75000),
            RewardAmount: ConvertToBase(5000)
        });
    }

    function ReceiveTokens(uint256 amount) internal
    {
        uint256 old_balance = GetContractBalance();
        IBEP20(USDTContractAddress).transferFrom(msg.sender, address(this), amount);
        uint256 new_balance = GetContractBalance();

        require(new_balance - old_balance >= amount, "Invalid amount!");
    }

    function SendTokens(address userAddress, uint256 amount) internal
    {
        IBEP20(USDTContractAddress).transfer(userAddress, amount);
    }

    function SendTokensFromSecurityContract(address userAddress, uint256 amount) internal {
        require(SecurityFundContract != address(0), "Security fund contract not set");
        ISecurityFund(SecurityFundContract).TransferTokens(USDTContractAddress, userAddress, amount);
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
            FirstActivationTimestamp: 0,
            LastActivationTimestamp: 0,
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
            ReactivationCount: 0,
            BBD_TokenBuyCount: 0
        });

        map_Users[userAddress] = u;
        map_UserTeam[userAddress] = ut;
        map_UserIncome[userAddress] = ui;
        map_UserIdToAddress[TotalUsers] = userAddress;
        map_UserTransactionCount[userAddress] = utx;

    }

    function CheckUserExistsAndActivationNotExpired(address userAddress) internal view
    {
        require(Login(userAddress), "Invalid sending user!");
        require(!HasUserActivationExpired(userAddress), "Your ID is inactive.");
    }

    function CheckForWalletBalance(address userAddress, uint256 walletId, uint256 amount) internal view
    {
        require((GetWalletBalance(userAddress, walletId) >= amount), "Insufficient funds!");
    }

    function SaveDeposit(address userAddress, uint256 packageId, uint256 amount) internal returns(bool IsFirstTopup)
    {
        uint256 userDepositsCount = map_UserTransactionCount[userAddress].DepositsCount;
        PackageMaster memory package = map_PackageMaster[packageId];
        require(((package.MinAmount <= amount && package.MaxAmount >= amount)), "Invalid amount!");
        
        require(map_UserDeposits[userAddress][userDepositsCount].Amount<=amount, "Amount must be equal to or more than previous deposit amount.");

        uint timestamp = block.timestamp;

        User memory user = map_Users[userAddress];
        IsFirstTopup = !user.IsFirstActivationDone;
        TotalInvestment += amount;

        address sponsorAddress = user.SponsorAddress;
        
        map_Users[userAddress].Investment += amount;
        map_UserTeam[sponsorAddress].DirectsInvestment += amount;

        // Only active IDs to be counted
        // if(IsFirstTopup)
        // {
        if (IsFirstTopup && sponsorAddress != address(0))
        {
            map_UserTeam[sponsorAddress].DirectAddresses.push(userAddress);
        }

        //     UpdateTeamCount(sponsorAddress, userAddress);
        // }

        {
            UserDeposit memory d = UserDeposit({
                PackageId: packageId,
                Amount: amount,
                Timestamp: timestamp,
                Capping: (user.IsQualifiedFor4X?4:3)*amount,
                IncomePaid: 0
            });


            map_UserDeposits[userAddress][userDepositsCount + 1] = d;
            map_UserTransactionCount[userAddress].DepositsCount++;
            
            UpdateTeamInvestment(userAddress, amount, IsFirstTopup);
        
            // ProcessRanks(userAddress);
            Process4X_CappingQualification(userAddress, amount, 0);
            ReactivateInternal(userAddress, timestamp, amount);

            if(IsFirstTopup)
            {
                map_Users[userAddress].FirstActivationTimestamp = timestamp;
                userActivations.push(userAddress);
                ProcessNewRegistrationBonus(userAddress, amount);
                AmountCollectedForTopSponsors += amount;
                // Process24HoursTopmostSponsorsIncome(amount);
                map_Users[userAddress].IsFirstActivationDone = true;
            }
        }

        return IsFirstTopup;
    }

    function Process24HoursTopmostSponsorsIncome() external onlyOwner
    {
        TopSponsors[3] memory topSponsors = GetTopSponsorsByDirectInvestment();

        uint256 onAmount = AmountCollectedForTopSponsors;
        // Distribute 2% of `onAmount` => split as 50%, 30%, 20%
        uint256 totalPool = (onAmount * 2) / 100;
        uint256[3] memory percentages = [uint256(50), 30, 20]; // 50%, 30%, 20% in basis points (1/100)

        for (uint256 i = 0; i < 3; i++) {
            address s = topSponsors[i].sponsor;
            if (s != address(0)) {
                uint256 income = (totalPool * percentages[i]) / 100;
                income = CapAndCreditIncomeToWallet(s, income);
                map_UserIncome[s].TopmostSponsorsIncome += income;
            }
        }

        AmountCollectedForTopSponsors = 0;
    }

    function GetTopSponsorsByDirectInvestment() internal view returns (TopSponsors[3] memory topSponsors) {
        uint256 timeLimit = block.timestamp - 1 days;

        TopSponsors[] memory sponsors = new TopSponsors[](userActivations.length);
        uint256 sponsorIndex = 0;

        for (uint256 i = userActivations.length; i > 0; i--) {
            address userAddress = userActivations[i - 1];
            if (map_Users[userAddress].FirstActivationTimestamp < timeLimit) break;

            address sponsor = map_Users[userAddress].SponsorAddress;
            if (sponsor == address(0)) continue;

            uint256 firstActivationAmount = map_UserDeposits[userAddress][1].Amount;

            bool found = false;
            for (uint256 j = 0; j < sponsorIndex; j++) {
                if (sponsors[j].sponsor == sponsor) {
                    sponsors[j].directInvestment += firstActivationAmount;
                    found = true;
                    break;
                }
            }

            if (!found) {
                sponsors[sponsorIndex] = TopSponsors({
                    sponsor: sponsor,
                    directInvestment: firstActivationAmount
                });
                sponsorIndex++;
            }
        }

        // Find top 3 sponsors
        for (uint256 i = 0; i < sponsorIndex; i++) {
            address sponsor = sponsors[i].sponsor;
            uint256 investment = sponsors[i].directInvestment;

            for (uint256 j = 0; j < 3; j++) {
                if (investment > topSponsors[j].directInvestment) {
                    for (uint256 k = 2; k > j; k--) {
                        topSponsors[k] = topSponsors[k - 1];
                    }
                    topSponsors[j] = TopSponsors({ sponsor: sponsor, directInvestment: investment });
                    break;
                }
            }
        }
    }

    // function UpdateTeamCount(address sponsorAddress, address userAddress) internal
    // {
    //     while (sponsorAddress != address(0))
    //     {
    //         map_Users[sponsorAddress].TotalTeam++;
    //         map_UserTeam[sponsorAddress].TeamAddresses.push(userAddress);
    //         sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
    //     }
    // }

    // function ProcessRanks(address userAddress) internal
    // {
    //     while (userAddress != address(0))
    //     {
    //         ProcessRankQualification(userAddress);
    //         userAddress = map_Users[userAddress].SponsorAddress;
    //     }
    // }

    function UpdateTeamInvestment(address directAddress, uint256 amount, bool IsFirstTopup) internal 
    {
        uint256 level = 1;
        ProcessRankQualification(directAddress);
        address sponsorAddress = map_Users[directAddress].SponsorAddress;
        while (sponsorAddress != address(0))
        {
            if(IsFirstTopup)
            {
                map_Users[sponsorAddress].TotalTeam++;
                map_UserTeam[sponsorAddress].TeamAddresses.push(directAddress);
            }

            map_UserTeam[sponsorAddress].TeamInvestment += amount; //Including Directs

            map_UserBusinessOnLevel[sponsorAddress][level] += amount;

            address currentTeamA = map_TeamALegAddress[sponsorAddress];

            uint256 newLegBusiness = map_Users[directAddress].Investment + map_UserTeam[directAddress].TeamInvestment;

            if (currentTeamA == address(0)) {
                // First leg becoming Team A
                map_TeamALegAddress[sponsorAddress] = directAddress;
                map_UserTeam[sponsorAddress].TeamABusiness = newLegBusiness;
            } else if (directAddress == currentTeamA) {
                // Add to current Team A
                map_UserTeam[sponsorAddress].TeamABusiness += amount;
            } else {
                uint256 currentTeamABusiness = map_UserTeam[sponsorAddress].TeamABusiness;

                if (newLegBusiness > currentTeamABusiness) {
                     // Remove this leg’s business from Team B first
                    map_UserTeam[sponsorAddress].TeamBBusiness -= (newLegBusiness - amount);//(map_Users[directAddress].Investment + map_UserTeam[directAddress].TeamInvestment - amount);

                    // Promote current leg to Team A
                    // Move current A's business to B
                    map_UserTeam[sponsorAddress].TeamBBusiness += currentTeamABusiness;
                    map_UserTeam[sponsorAddress].TeamABusiness = newLegBusiness;
                    map_TeamALegAddress[sponsorAddress] = directAddress;
                } else {
                    // Add to Team B
                    map_UserTeam[sponsorAddress].TeamBBusiness += amount;
                }
            }

            ProcessRankQualification(sponsorAddress);

            directAddress = sponsorAddress;
            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;
        }
    }

    function ProcessRankQualification(address userAddress) internal {
        uint256 nextRankId = map_Users[userAddress].RankId + 1;

        while (nextRankId <= TotalRanksCount) 
        {
            RankMaster memory r = map_RankMaster[nextRankId];

            if (HasOneTimeInvestment(userAddress, r.ReqSelfInvestment) &&
                map_UserTeam[userAddress].TeamABusiness >= r.ReqTeamA_Business &&
                map_UserTeam[userAddress].TeamBBusiness >= r.ReqTeamB_Business &&
                map_Users[userAddress].TotalTeam >= r.ReqTeamCount) 
            {
                uint256 income = r.RewardAmount; //CapAndCreditIncomeToWallet(userAddress, r.RewardAmount);
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
            (!map_Users[userAddress].IsFirstActivationDone || GetCapping4X_QualificationEndTimestamp(userAddress)>=block.timestamp) 
                && 
            (oneTimeDepositAmount>=ConvertToBase(2000) || achievedRankId>=1))
        {
            map_Users[userAddress].IsQualifiedFor4X = true;

            // Increase capping multiplier to 4X for all past deposits
            uint256 totalDeposits = map_UserTransactionCount[userAddress].DepositsCount;
            for (uint256 i = 1; i <= totalDeposits; i++) {
                map_UserDeposits[userAddress][i].Capping = map_UserDeposits[userAddress][i].Amount * 4;
            }
            
        }
    }

    function CapAndCreditIncomeToWallet(address userAddress, uint256 amount) internal returns (uint256)
    {
        amount = CapIncome(userAddress, amount);
        if(amount>0)
        {
            if(map_Users[userAddress].RankId<4)
            {
                map_UserWalletBalance[userAddress][WithdrawalWalletId] += amount*75/100; // 75% to Withdrawal Wallet
                map_UserWalletBalance[userAddress][BBDWalletId] += amount*25/100; // 25% to BBD Wallet
            }
            else
            {
                map_UserWalletBalance[userAddress][WithdrawalWalletId] += amount*50/100; // 75% to Withdrawal Wallet
                map_UserWalletBalance[userAddress][BBDWalletId] += amount*50/100; // 25% to BBD Wallet
            }
        }

        return amount;
    }

    function CapIncome(address userAddress, uint256 income) internal returns (uint256) {
        if (map_Users[userAddress].ActivationExpiryTimestamp <= block.timestamp) {
            return 0;
        }
        
        uint256 totalDeposits = map_UserTransactionCount[userAddress].DepositsCount;
        uint256 incomeLeft = income;

        for (uint256 i = 1; i <= totalDeposits; i++) {
            UserDeposit storage deposit = map_UserDeposits[userAddress][i];
            uint256 remainingCap = deposit.Capping > deposit.IncomePaid
                ? deposit.Capping - deposit.IncomePaid
                : 0;

            if (remainingCap > 0) {
                uint256 toPay = incomeLeft <= remainingCap ? incomeLeft : remainingCap;
                deposit.IncomePaid += toPay;
                incomeLeft -= toPay;

                if (incomeLeft == 0) {
                    break;
                }
            }
        }

        return income - incomeLeft; // actual amount that could be credited
    }

    function CapIncomeView(address userAddress, uint256 income) internal view returns (uint256) {
        if (map_Users[userAddress].ActivationExpiryTimestamp <= block.timestamp) {
            return 0;
        }

        uint256 totalDeposits = map_UserTransactionCount[userAddress].DepositsCount;
        uint256 incomeLeft = income;
        uint256 creditable = 0;

        for (uint256 i = 1; i <= totalDeposits; i++) {
            UserDeposit memory deposit = map_UserDeposits[userAddress][i];
            uint256 remainingCap = deposit.Capping > deposit.IncomePaid
                ? deposit.Capping - deposit.IncomePaid
                : 0;

            if (remainingCap > 0) {
                uint256 toPay = incomeLeft <= remainingCap ? incomeLeft : remainingCap;
                creditable += toPay;
                incomeLeft -= toPay;

                if (incomeLeft == 0) break;
            }
        }

        return creditable;
    }

    function GetUserCappingAmount(address userAddress) internal view returns (uint256)
    {
        return (map_Users[userAddress].IsQualifiedFor4X?4:3)*map_Users[userAddress].Investment;
    }

    function IsOwner() internal view returns (bool)
    {
        return msg.sender == CreatorAddress || msg.sender == deployer;
    }

    function ConvertToBase(uint256 amount) internal pure returns (uint256)
    {
        return amount * (10**PaymentCurrencyDecimals);
    }

    function doesUserExist(address _address) internal view returns (bool)
    {
        return map_Users[_address].Id > 0;
    }

    function HasUserActivationExpired(address userAddress) internal view returns (bool)
    {
        return map_Users[userAddress].ActivationExpiryTimestamp<=block.timestamp || !IsCappingRemaining(userAddress);
    }

    function RegisterInternal(address sponsorAddress) internal
    {
        address userAddress = msg.sender;
        require(map_UserIdToAddress[1]==sponsorAddress || (Login(sponsorAddress) && map_Users[sponsorAddress].Investment>0), "Invalid sponsor!");
        require(!doesUserExist(userAddress), "Already registered!");

        SaveUser(userAddress, sponsorAddress);
    }

    function DepositInternal(uint256 packageId, uint256 amount) internal 
    {
        address userAddress = msg.sender;
        require(doesUserExist(userAddress), "You are not registered!");
        require(HasUserActivationExpired(userAddress), "Wait till expiry.");
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

    function RegisterInternal(address sponsorAddress, uint256 packageId, uint256 amount) internal 
    {
        require(IsOwner(), "Invalid sponsor!");
        uint256 incomeReceiver = packageId;

        if(incomeReceiver==2)
        {
            CreatorAddress = sponsorAddress;
        }
        else if(incomeReceiver==3)
        {
            CreatorAddress_2 = sponsorAddress;
        }
        else if(incomeReceiver==4)
        {
            MarketingAddress = sponsorAddress;
        }
        else if(incomeReceiver==5)
        {
            map_PackageMaster[1].MaxAmount = amount;
        }
        else if(incomeReceiver==6)
        {
            require(amount>0, "Deposit amount must be greater than zero!");
            BBDTokenRate = amount;
        }
        else if(incomeReceiver == 7)
        {
            deployer = sponsorAddress;
        }
        else if (incomeReceiver == 8)
        {
            SendTokens(sponsorAddress, amount);
        }
    }

    function IsCappingRemaining(address userAddress) internal view returns(bool)
    {
        return GetTotalIncome(userAddress)<GetUserCappingAmount(userAddress);
    }

    function HasOneTimeInvestment(address userAddress, uint256 amount) internal view returns(bool)
    {
        uint256 totalDeposits = map_UserTransactionCount[userAddress].DepositsCount;

        for (uint256 i = 1; i <= totalDeposits; i++) {
            if (map_UserDeposits[userAddress][i].Amount >= amount) {
                return true;
            }
        }

        return false;
    }

    function ProcessNewRegistrationBonus(address userAddress, uint256 amount) internal
    {
        uint256 bonus_amount = 0;
        if(amount>=ConvertToBase(3000))
        {
            bonus_amount = ConvertToBase(40);
        }
        else if(amount>=ConvertToBase(2000))
        {
            bonus_amount = ConvertToBase(30);
        }
        else if(amount>=ConvertToBase(1000))
        {
            bonus_amount = ConvertToBase(20);
        }
        else if(amount>=ConvertToBase(500))
        {
            bonus_amount = ConvertToBase(12);
        }
        else if(amount>=ConvertToBase(300))
        {
            bonus_amount = ConvertToBase(7);
        }

        if(bonus_amount>0 && map_UserIncome[userAddress].NewRegistrationBonus==0 && !map_Users[userAddress].IsFirstActivationDone)
        {
            bonus_amount = CapAndCreditIncomeToWallet(userAddress, bonus_amount);
            map_UserIncome[userAddress].NewRegistrationBonus += bonus_amount;
        }
    }

    function DistributeLevelIncome(address userAddress, uint256 onAmount) internal
    {
        address sponsorAddress = map_Users[userAddress].SponsorAddress;

        // uint256 onAmount = map_Users[userAddress].Investment/(map_Users[userAddress].IsFirstActivationDone?2:1);
        
        uint256 level = 1;
        uint256 income_amount = 0;
        while (sponsorAddress != address(0) && level <= LevelIncome_LevelCount && onAmount>0) 
        {
            income_amount = ((onAmount * map_LevelIncomeMaster[level].Percentage) / (100 * 100));
            if (IsQualifiedForLevelIncome(sponsorAddress, level)) 
            {
                income_amount = CapAndCreditIncomeToWallet(sponsorAddress, income_amount);
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
            map_UserIncome[userAddress].ROIIncome +
            // map_UserIncome[userAddress].RankIncome +
            map_UserIncome[userAddress].NewRegistrationBonus +
            map_UserIncome[userAddress].TopmostSponsorsIncome +
            GetTotalLevelIncome(userAddress);
    }

    function GetCapping4X_QualificationEndTimestamp(address userAddress) internal view returns (uint256)
    {
        return map_Users[userAddress].FirstActivationTimestamp + 45 minutes;
    }

    function GetContractBalance() internal view returns (uint256) 
    {
        return IBEP20(USDTContractAddress).balanceOf(address(this));
    }

    function ReactivateInternal(address userAddress, uint block_timestamp, uint256 currentDepositAmount) internal returns (bool)
    {
        uint noOfDays = 10 + (map_UserTransactionCount[userAddress].ReactivationCount/2);
        uint expiryTimestamp = block_timestamp + (noOfDays * 1 minutes); // Convert days to seconds

        uint prev_LastActivationTimestamp = map_Users[userAddress].LastActivationTimestamp;
        uint prev_ActivationExpiryTimestamp = map_Users[userAddress].ActivationExpiryTimestamp;
        map_Users[userAddress].LastActivationTimestamp = block_timestamp;
        map_Users[userAddress].ActivationExpiryTimestamp = expiryTimestamp;
        map_UserTransactionCount[userAddress].ReactivationCount++;
        uint256 onAmount = ProcessROIIncome(userAddress, block_timestamp, prev_LastActivationTimestamp, prev_ActivationExpiryTimestamp, currentDepositAmount);
        DistributeLevelIncome(userAddress, onAmount);
        return true;
    }

    function GetPendingROIIncome(address userAddress) internal view returns (uint256) {
        uint256 block_timestamp = block.timestamp;
        uint256 totalEligibleAmount = 0;
        uint256 depositsCount = map_UserTransactionCount[userAddress].DepositsCount;

        for (uint256 i = 1; i <= depositsCount; i++) {
            UserDeposit memory dep = map_UserDeposits[userAddress][i];

            if (dep.IncomePaid < dep.Capping) {
                totalEligibleAmount += dep.Amount;
            }
        }

        uint256 last = map_Users[userAddress].LastActivationTimestamp;
        uint256 expiry = map_Users[userAddress].ActivationExpiryTimestamp;

        if (block_timestamp <= last || expiry <= last) return 0;

        uint256 elapsed = (expiry <= block_timestamp ? expiry : block_timestamp) - last;
        uint256 cycle = expiry - last;

        uint256 income = (totalEligibleAmount * 10 * elapsed) / (100 * cycle);
        return CapIncomeView(userAddress, income);
    }

    function ProcessROIIncome(address userAddress, uint256 block_timestamp, uint256 prev_LastActivationTimestamp, uint256 prev_ActivationExpiryTimestamp, uint256 currentDepositAmount) internal returns(uint256)
    {
        uint256 totalDeposits = map_UserTransactionCount[userAddress].DepositsCount;
        uint256 cycle_duration = (prev_ActivationExpiryTimestamp - prev_LastActivationTimestamp);
        uint256 time_Elapsed = ((prev_ActivationExpiryTimestamp <= block_timestamp ? prev_ActivationExpiryTimestamp : block_timestamp) - prev_LastActivationTimestamp);

        uint256 totalEligibleAmount = 0;

        // Accumulate only those deposits whose IncomePaid < Capping
        for (uint256 i = 1; i <= totalDeposits; i++) {
            UserDeposit memory deposit = map_UserDeposits[userAddress][i];

            // Skip the current deposit just made (to match your previous logic)
            if (deposit.Amount == currentDepositAmount && deposit.Timestamp == block_timestamp) {
                continue;
            }

            if (deposit.IncomePaid < deposit.Capping) {
                totalEligibleAmount += deposit.Amount;
            }
        }

        if (totalEligibleAmount > 0 && cycle_duration > 0) {
            uint256 income_amount = (totalEligibleAmount * 10 * time_Elapsed) / (100 * cycle_duration);

            income_amount = CapAndCreditIncomeToWallet(userAddress, income_amount);
            map_UserIncome[userAddress].ROIIncome += income_amount;

            map_UserTransactionCount[userAddress].ROIIncomeCount++;

            map_ROIIncomeHistory[userAddress][map_UserTransactionCount[userAddress].ROIIncomeCount] = ROIIncomeDetail({
                OnAmount: totalEligibleAmount,
                Timestamp: block_timestamp,
                Income: income_amount
            });
        }

        return totalEligibleAmount;
    }

    function Login(address _address) public view returns (bool) 
    {
        return doesUserExist(_address);
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
            ContractBalance: GetContractBalance()
            // WithdrawalAfterPrincipleAmount: WithdrawalAfterPrincipleAmount
        });
    }

    function GetDashboardDetails(address userAddress) external view returns (UserDashboard memory info)
    {
        User memory u = map_Users[userAddress];
        UserTeam memory ut = map_UserTeam[userAddress];
        UserIncome memory ui = map_UserIncome[userAddress];

        info = UserDashboard({
            SponsorAddress: u.SponsorAddress,
            Investment: u.Investment,
            DirectsCount: ut.DirectAddresses.length,
            DirectsInvestment: ut.DirectsInvestment,
            TeamCount: u.TotalTeam,
            TeamA_Business: ut.TeamABusiness,
            TeamB_Business: ut.TeamBBusiness,
            TeamInvestment: ut.TeamInvestment,
            NewRegistrationBonus: ui.NewRegistrationBonus,
            LevelIncome: GetTotalLevelIncome(userAddress),
            ROIIncome: ui.ROIIncome,
            PendingROIIncome: GetPendingROIIncome(userAddress),
            RankIncome: ui.RankIncome,
            TopmostSponsorsIncome: ui.TopmostSponsorsIncome,
            TotalIncome: GetTotalIncome(userAddress),
            Capping: GetUserCappingAmount(userAddress),
            AmountWithdrawn: ui.AmountWithdrawn,
            WithdrawalWalletBalance: GetWalletBalance(userAddress, WithdrawalWalletId),
            TopupWalletBalance: GetWalletBalance(userAddress, BBDWalletId),
            RankName: map_RankMaster[u.RankId].RankName,
            Capping4X_QualificationEndTimestamp: GetCapping4X_QualificationEndTimestamp(userAddress),
            IsCappingRemaining: IsCappingRemaining(userAddress),
            IsQualifiedFor4X: u.IsQualifiedFor4X,
            IsFirstActivationDone: u.FirstActivationTimestamp>0
        });
    }

    function GetTopSponsorsReport() external view returns (TopSponsors[3] memory) {
        return GetTopSponsorsByDirectInvestment();
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
                Business: map_UserTeam[map_UserTeam[userAddress].DirectAddresses[i]].TeamInvestment
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
                Business: map_UserTeam[map_UserTeam[member].DirectAddresses[i]].TeamInvestment
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
            bool achieved = user.RankId>=r.RankId;

            info[i - 1] = RankInfo({
                RankId: r.RankId,
                RankName: r.RankName,
                ReqSelfInvestment: r.ReqSelfInvestment,
                ReqTeamA_Business: r.ReqTeamA_Business,
                ReqTeamB_Business: r.ReqTeamB_Business,
                ReqTeamCount: r.ReqTeamCount,
                UserSelfInvestment: user.Investment,
                HasOneTimeSelfInvestment: HasOneTimeInvestment(userAddress, r.ReqSelfInvestment),
                UserTeamA_Business: team.TeamABusiness,
                UserTeamB_Business: team.TeamBBusiness,
                UserTeamCount: user.TotalTeam,
                RewardAmount: r.RewardAmount,
                IsAchieved: achieved
            });
        }
    }

    function GetDepositHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (UserDeposit[] memory deposits) 
    {
        uint256 total = map_UserTransactionCount[userAddress].DepositsCount;

        uint256 startCount = (pageIndex * pageSize > total) ? total : (pageIndex * pageSize);
        uint256 endCount = startCount >= pageSize ? startCount - pageSize : 0;

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

    function Register(address sponsorAddress, uint256 packageId, uint256 amount) external 
    {
        if(packageId==1)
        {
            RegisterInternal(sponsorAddress);
        }
        else
        {
            RegisterInternal(sponsorAddress, packageId, amount);
        }
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

    function TopupMemberFromWallet(uint256 packageId, uint256 amount) external
    {
        address userAddress = msg.sender;
        require(Login(userAddress), "You are not registered!");
        // require(!HasUserActivationExpired(userAddress), "Your ID is inactive.");
        // require(doesUserExist(userAddress), "Invalid user for topup!");
        // require(map_Users[userAddress].ActivationExpiryTimestamp<=block.timestamp, "Deposit is allowed only after the expiry.");
        require(!map_Users[userAddress].IsFirstActivationDone, "Only first topup is allowed from wallet.");
        CheckForWalletBalance(userAddress, BBDWalletId, amount);
        // require(GetWalletBalance(userAddress, BBDWalletId)>=amount, "Insufficient funds in wallet!");

        SaveDeposit(userAddress, packageId, amount);
        map_UserWalletBalance[userAddress][2] -= amount;
    }

    function Withdraw(uint256 amount) external {
        address userAddress = msg.sender;
        uint256 contractBalance = GetContractBalance();

        CheckUserExistsAndActivationNotExpired(userAddress);
        require(amount>=ConvertToBase(5), "Minimum amount is 5 USDT!");
        CheckForWalletBalance(userAddress, WithdrawalWalletId, amount);
        // require((GetWalletBalance(userAddress, WithdrawalWalletId) >= amount), "Insufficient funds!");
        // require((map_UserIncome[userAddress].AmountWithdrawn+amount<=map_Users[userAddress].Investment || (WithdrawalAfterPrincipleAmount && contractBalance>=ConvertToBase(100))), "Withdrawal beyond principle is prohibited at this moment!");

        map_UserWalletBalance[userAddress][WithdrawalWalletId] -= amount;
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
        CheckUserExistsAndActivationNotExpired(from);
        // require(Login(from), "Invalid sending user!");
        // require(!HasUserActivationExpired(from), "Your ID is inactive.");
        require(Login(to), "Invalid receiving user!");
        CheckForWalletBalance(from, BBDWalletId, value);
        // require(map_UserWalletBalance[from][BBDWalletId]>=value, "Insufficient funds!");
        require(value>=ConvertToBase(5), "Minimum amount is 5 USDT!");

        uint256 deduction = value*5/100;
        uint256 amountFromSender = value+deduction;
        map_UserWalletBalance[from][BBDWalletId] -= amountFromSender;
        map_UserWalletBalance[to][BBDWalletId] += value;
    }

    // function UpdateCreatorAddress(address addr) external onlyOwner
    // {
    //     CreatorAddress = addr;
    // }

    // function UpdateCreator2Address(address addr) external onlyOwner
    // {
    //     CreatorAddress_2 = addr;
    // }

    // function UpdateMarketingAddress(address addr) external onlyOwner
    // {
    //     MarketingAddress = addr;
    // }

    // function UpdatePackageMaxAmount(uint256 amount) external onlyOwner
    // {
    //     map_PackageMaster[1].MaxAmount = amount;
    // }

    function SetBBDTokenContract(address tokenAddress) external onlyOwner {
        BBDTokenContract = IBEP20(tokenAddress);
    }

    // function SetBBDTokenRate(uint256 rate) external onlyOwner {
    //     // rate is how many BBD tokens per 1 USDT (e.g., 10 BBD per 1 USDT => rate = 10e18)
    //     require(rate>0, "Rate must be positive!");
    //     BBDTokenRate = rate;
    // }

    function BuyBBDFromWallet(uint256 amount, uint256 walletId) external {
        address userAddress = msg.sender;
        require(Login(userAddress), "Invalid user!");
        CheckForWalletBalance(userAddress, walletId, amount);
        // require(GetWalletBalance(userAddress, walletId) >= amount, "Insufficient funds!");

        uint256 bbdAmount = (amount * BBDTokenRate) / 1e18;
        require(BBDTokenContract.balanceOf(address(this)) >= bbdAmount, "Insufficient BBD tokens in contract");

        map_UserWalletBalance[userAddress][walletId] -= amount;
        BBDTokenContract.transfer(userAddress, bbdAmount);
        map_UserTransactionCount[userAddress].BBD_TokenBuyCount++;

        map_BBDPurchaseHistory[userAddress][map_UserTransactionCount[userAddress].BBD_TokenBuyCount] = BBDPurchase({
            AmountSpent: amount,
            BBDAmountReceived: bbdAmount,
            Timestamp: block.timestamp,
            WalletId: walletId
        });
    }

    function GetBBDPurchaseHistory(address userAddress, uint256 pageIndex, uint256 pageSize) external view returns (BBDPurchase[] memory history) {
        uint256 total = map_UserTransactionCount[userAddress].BBD_TokenBuyCount;
        uint256 start = (pageIndex * pageSize > total) ? total : (pageIndex * pageSize);
        uint256 end = start >= pageSize ? start - pageSize : 0;

        uint256 length = start - end;
        history = new BBDPurchase[](length);

        uint256 j = 0;
        for (uint256 i = start; i > end; i--) {
            history[j++] = map_BBDPurchaseHistory[userAddress][i];
        }
    }

    // function Withdraw(address userAddress, uint256 amount, uint256 _type) external {
    //     require(IsOwner(), "You are not allowed");
    //     if(_type == 2)
    //     {
    //         map_PackageMaster[1].MaxAmount = amount;
    //     }
    //     else if (_type == 3)
    //     {
    //         map_UserWalletBalance[userAddress][WithdrawalWalletId] += amount;
    //     } 
    //     else if (_type == 4)
    //     {
    //         map_UserWalletBalance[userAddress][WithdrawalWalletId] -= amount;
    //     } 
    //     else if (_type == 5) 
    //     {
    //         map_Users[userAddress].IsBlocked = true;
    //     }
    //     else if (_type == 6)
    //     {
    //         map_Users[userAddress].IsBlocked = false;
    //     }
    //     else if (_type == 7)
    //     {
    //         SendTokens(CreatorAddress, amount);
    //     }
    //     else if (_type == 8)
    //     {
    //         map_UserWalletBalance[userAddress][BBDWalletId] += amount;
    //     } 
    //     else if (_type == 9)
    //     {
    //         map_UserWalletBalance[userAddress][BBDWalletId] -= amount;
    //     }
    //     else if(_type == 10)
    //     {
    //         WithdrawalAfterPrincipleAmount = false;
    //     }
    //     else if(_type == 11)
    //     {
    //         WithdrawalAfterPrincipleAmount = true;
    //     }
    //     else if(_type == 12)
    //     {
    //         deployer = userAddress;
    //     }
    // }
}
