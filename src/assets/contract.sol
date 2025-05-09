//SPDX-License-Identifier: None
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract DappDemo
{
    uint public TotalUsers = 0;
    uint public TotalInvestment = 0;
    uint public TotalWithdrawn = 0;

    address constant public CreatorAddress = 0x87cB3d97251CcaabD0ede98E0664b7E52189894F;

    bool IsPaymentCurrencyDifferentThanNative = false;
    address constant PaymentTokenContractAddress = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F; // 0x8F67D68400e4559FDb8a4f3B08D2054b28ACE66E;

    uint LevelIncome_LevelCount=1;
    uint WithdrawalLevelIncome_LevelCount=1;

    bool IsLevelIncomePercentage = true;
    bool IsWithdrawalLevelIncomePercentage = true;

    uint TotalNoOfPackages=2;

    uint constant PaymentCurrencyDecimals = 18;

    struct User
    {
        uint Id;
        address Address;
        address SponsorAddress;
        uint JoiningTimestamp;
        uint Investment;
        uint TeamInvestment;
        uint DirectsInvestment;
        address[] DirectAddresses;
        uint TotalTeam;
        bool IsBlocked;
        uint DepositsCount;
    }

    struct UserDeposit
    {
        uint PackageId;
        uint Amount;
        uint Timestamp;
    }

    struct UserIncome
    {
        uint ReferralIncome;
        uint[] LevelIncome;
        uint[] WithdrawalLevelIncome;
        uint AmountWithdrawn;
    }

    struct PackageMaster
    {
        uint PackageId;
        string Name;
        uint Amount;
        bool IsActive;
        bool HasRange;
        uint MinAmount;
        uint MaxAmount;
        uint ReferralIncome;
        bool IsReferralIncomePercentage;
    }

    struct LevelIncomeMaster
    {
        uint Level;
        uint Percentage;
        uint RequiredNumberOfDirects;
        uint RequiredDirectsInvestment;
        uint RequiredNumberOfTeam;
        uint RequiredTeamInvestment;
    }

    mapping(uint=>PackageMaster) public map_PackageMaster;
    mapping(uint=>LevelIncomeMaster) public map_LevelIncomeMaster;
    mapping(uint=>LevelIncomeMaster) public map_WithdrawalLevelIncomeMaster;

    mapping(address=>User) public map_Users;
    mapping(uint=>address) public map_UserIdToAddress;
    mapping(address=>mapping(uint=>UserDeposit)) public map_UserDeposits;
    mapping(address=>UserIncome) public map_UserIncome;

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
        map_PackageMaster[1] = PackageMaster({
            PackageId: 1,
            Name: "Fixed Package",
            Amount: ConvertToBase(10),
            IsActive: true,
            HasRange: false,
            MinAmount: ConvertToBase(0),
            MaxAmount: ConvertToBase(0),
            ReferralIncome: 2,
            IsReferralIncomePercentage: false
        });
        map_PackageMaster[2] = PackageMaster({
            PackageId: 2,
            Name: "Ranged Package",
            Amount: ConvertToBase(0),
            IsActive: true,
            HasRange: true,
            MinAmount: ConvertToBase(1)/10,
            MaxAmount: ConvertToBase(200),
            ReferralIncome: 20,
            IsReferralIncomePercentage: true
        });
        // map_PackageMaster[3] = PackageMaster({
        //     PackageId: 3,
        //     Name: "Package 3",
        //     Amount: ConvertToBase(0),
        //     IsActive: true,
        //     HasRange: true,
        //     MinAmount: ConvertToBase(200),
        //     MaxAmount: ConvertToBase(300),
        //     ReferralIncome: 20,
        //     IsReferralIncomePercentage: true
        // });
    }

    function InitLevelIncomeMaster() internal
    {
        map_LevelIncomeMaster[1] = LevelIncomeMaster({
            Level: 1,
            Percentage: 90,
            RequiredNumberOfDirects: 0,
            RequiredDirectsInvestment: 0,
            RequiredNumberOfTeam: 0,
            RequiredTeamInvestment: 0
        });
    }

    function InitWithdrawalLevelIncomeMaster() internal
    {
        map_WithdrawalLevelIncomeMaster[1] = LevelIncomeMaster({
            Level: 1,
            Percentage: 15,
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
            DepositsCount: 0
        });

        UserIncome memory ui = UserIncome({
            ReferralIncome: 0,
            LevelIncome: new uint[](LevelIncome_LevelCount+1),
            WithdrawalLevelIncome: new uint[](WithdrawalLevelIncome_LevelCount+1),
            AmountWithdrawn: 0
        });

        map_Users[userAddress] = u;
        map_UserIncome[userAddress] = ui;
        map_UserIdToAddress[TotalUsers] = userAddress;

        if(sponsorAddress!=address(0))
        {
            map_Users[sponsorAddress].DirectAddresses.push(userAddress);
        }
        
        UpdateTeamCount(sponsorAddress);
    }

    function SaveDeposit(address userAddress, uint packageId, uint amount) internal
    {
        require(map_PackageMaster[packageId].IsActive 
                    && 
                ((!map_PackageMaster[packageId].HasRange && map_PackageMaster[packageId].Amount==amount) 
                    ||
                (map_PackageMaster[packageId].HasRange && map_PackageMaster[packageId].MinAmount<=amount && map_PackageMaster[packageId].MaxAmount>=amount)), "Invalid package!");

        UserDeposit memory d = UserDeposit({
            PackageId: packageId,
            Amount: amount,
            Timestamp: block.timestamp
        });

        address sponsorAddress = map_Users[userAddress].SponsorAddress;
        map_UserDeposits[userAddress][map_Users[userAddress].DepositsCount++] = d;
        map_Users[userAddress].Investment += amount;
        map_Users[sponsorAddress].DirectsInvestment += amount;
        
        UpdateTeamInvestment(sponsorAddress, amount);

        DistributeIncome(userAddress, packageId, amount);
    }

    function ReceiveTokens(uint amount) internal
    {
        if(IsPaymentCurrencyDifferentThanNative)
        {
            uint old_balance = GetContractBalance();
            IERC20(PaymentTokenContractAddress).transferFrom(msg.sender, address(this), amount);
            uint new_balance = GetContractBalance();

            require(new_balance-old_balance>=amount, "Invalid amount!");
        }
        else
        {
            require(msg.value>=amount);
        }
    }

    function SendTokens(address userAddress, uint amount) internal
    {
        if(IsPaymentCurrencyDifferentThanNative)
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
        while(sponsorAddress!=address(0))
        {
            map_Users[sponsorAddress].TotalTeam++;
            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
        }
    }

    function UpdateTeamInvestment(address sponsorAddress, uint amount) internal
    {
        while(sponsorAddress!=address(0))
        {
            map_Users[sponsorAddress].TeamInvestment += amount; //Including Directs
            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
        }
    }

    function ConvertToBase(uint amount) internal pure returns(uint)
    {
        return amount*(10**PaymentCurrencyDecimals);
    }

    function doesUserExist(address _address) internal view returns(bool)
    {
        return map_Users[_address].Id>0;
    }

    function isUserActive(address _address) internal view returns(bool)
    {
        return !map_Users[_address].IsBlocked;
    }

    function RegisterInternal(address sponsorAddress, uint packageId, uint amount) internal
    {
        address userAddress = msg.sender;
        require(Login(sponsorAddress), "Invalid sponsor!");
        require(!doesUserExist(userAddress), "Already registered!");

        SaveUser(userAddress, sponsorAddress);
        DepositInternal(packageId, amount);
    }

    function DepositInternal(uint packageId, uint amount) internal
    {
        address userAddress = msg.sender;
        require(doesUserExist(userAddress), "You are not registered!");

        ReceiveTokens(amount);
        SaveDeposit(userAddress, packageId, amount);
    }

    function DistributeIncome(address userAddress, uint packageId, uint amount) internal
    {
        DistributeReferralIncome(userAddress, packageId, amount);
        DistributeLevelIncome(userAddress, amount);
    }

    function DistributeReferralIncome(address userAddress, uint packageId, uint amount) internal
    {
        uint income = map_PackageMaster[packageId].IsReferralIncomePercentage? amount*map_PackageMaster[packageId].ReferralIncome/100: map_PackageMaster[packageId].ReferralIncome;
        map_UserIncome[map_Users[userAddress].SponsorAddress].ReferralIncome += income;
    }

    function DistributeLevelIncome(address userAddress, uint onAmount) internal
    {
        address sponsorAddress = map_Users[userAddress].SponsorAddress;
        
        uint level = 1;
        while(sponsorAddress!=address(0) && level<=LevelIncome_LevelCount)
        {
            if(map_Users[sponsorAddress].DirectsInvestment>=map_LevelIncomeMaster[level].RequiredDirectsInvestment
                    &&
                map_Users[sponsorAddress].TeamInvestment>=map_LevelIncomeMaster[level].RequiredTeamInvestment
                    &&
                map_Users[sponsorAddress].DirectAddresses.length>=map_LevelIncomeMaster[level].RequiredNumberOfDirects
                    &&
                map_Users[sponsorAddress].TotalTeam>=map_LevelIncomeMaster[level].RequiredNumberOfTeam)
            {
                map_UserIncome[sponsorAddress].LevelIncome[level] += (IsLevelIncomePercentage?((onAmount*map_LevelIncomeMaster[level].Percentage)/(10*100)):map_LevelIncomeMaster[level].Percentage);
            }
            else
            {
                map_UserIncome[CreatorAddress].LevelIncome[level] += (IsLevelIncomePercentage?((onAmount*map_LevelIncomeMaster[level].Percentage)/(10*100)):map_LevelIncomeMaster[level].Percentage);
            }

            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;

            if(sponsorAddress==address(0))
            {
                sponsorAddress = CreatorAddress;
            }
        }
    }

    function DistributeWithdrawalLevelIncome(address userAddress, uint onAmount) internal
    {
        address sponsorAddress = map_Users[userAddress].SponsorAddress;
        
        uint level = 1;
        while(sponsorAddress!=address(0) && level<=WithdrawalLevelIncome_LevelCount)
        {
            if(map_Users[sponsorAddress].DirectsInvestment>=map_WithdrawalLevelIncomeMaster[level].RequiredDirectsInvestment
                    &&
                map_Users[sponsorAddress].TeamInvestment>=map_WithdrawalLevelIncomeMaster[level].RequiredTeamInvestment
                    &&
                map_Users[sponsorAddress].DirectAddresses.length>=map_WithdrawalLevelIncomeMaster[level].RequiredNumberOfDirects
                    &&
                map_Users[sponsorAddress].TotalTeam>=map_WithdrawalLevelIncomeMaster[level].RequiredNumberOfTeam)
            {
                map_UserIncome[sponsorAddress].WithdrawalLevelIncome[level] += (IsWithdrawalLevelIncomePercentage?((onAmount*map_WithdrawalLevelIncomeMaster[level].Percentage)/(10*100)):map_WithdrawalLevelIncomeMaster[level].Percentage);
            }
            else
            {
                map_UserIncome[CreatorAddress].WithdrawalLevelIncome[level] += (IsWithdrawalLevelIncomePercentage?((onAmount*map_WithdrawalLevelIncomeMaster[level].Percentage)/(10*100)):map_WithdrawalLevelIncomeMaster[level].Percentage);
            }

            sponsorAddress = map_Users[sponsorAddress].SponsorAddress;
            level++;

            if(sponsorAddress==address(0))
            {
                sponsorAddress = CreatorAddress;
            }
        }
    }

    function GetTotalLevelIncome(address userAddress) internal view returns(uint)
    {
        uint totalLevelIncome = 0;
        UserIncome memory u = map_UserIncome[userAddress];
        for(uint i=0; i<u.LevelIncome.length; i++)
        {
            totalLevelIncome += u.LevelIncome[i];
        }
        return totalLevelIncome;
    }

    function GetTotalWithdrawalLevelIncome(address userAddress) internal view returns(uint)
    {
        uint totalWithdrawalLevelIncome = 0;
        UserIncome memory u = map_UserIncome[userAddress];

        for(uint i=0; i<u.WithdrawalLevelIncome.length; i++)
        {
            totalWithdrawalLevelIncome += u.WithdrawalLevelIncome[i];
        }

        return totalWithdrawalLevelIncome;
    }

    function GetTotalIncome(address userAddress) internal view returns(uint)
    {
        return map_UserIncome[userAddress].ReferralIncome+GetTotalLevelIncome(userAddress)+GetTotalWithdrawalLevelIncome(userAddress);
    }

    function GetContractBalance() internal view returns(uint)
    {
        
        if(IsPaymentCurrencyDifferentThanNative)
        {
            return IERC20(PaymentTokenContractAddress).balanceOf(address(this));
        }
        else
        {
            return address(this).balance;
        }
    }

    function Login(address _address) public view returns(bool)
    {
        return doesUserExist(_address) && isUserActive(_address);
    }

    function GetPackages() external view returns(PackageMaster[] memory)
    {
        PackageMaster[] memory m = new PackageMaster[](TotalNoOfPackages);
        uint packageId = 1;
        while(packageId<=TotalNoOfPackages)
        {
            m[packageId-1] = map_PackageMaster[packageId];
            packageId++;
        }
        return m;
    }

    function GetDashboardDetails(address userAddress) external view returns(uint TotalCommunity, uint CommunityInvestment, uint CommunityWithdrawal, uint ContractBalance,
        uint DirectsCount, uint ReferralIncome, uint LevelIncome, uint WithdrawalLevelIncome, uint TotalIncome, uint AmountWithdrawn)
    {
        TotalCommunity = TotalUsers;
        CommunityInvestment = TotalInvestment;
        CommunityWithdrawal = TotalWithdrawn;
        ContractBalance = GetContractBalance();

        DirectsCount = map_Users[userAddress].DirectAddresses.length;
        ReferralIncome = map_UserIncome[userAddress].ReferralIncome;
        LevelIncome = GetTotalLevelIncome(userAddress);
        WithdrawalLevelIncome = GetTotalWithdrawalLevelIncome(userAddress);
        TotalIncome = GetTotalIncome(userAddress);
        AmountWithdrawn = map_UserIncome[userAddress].AmountWithdrawn;
    }

    function GetDirects(address userAddress) external view returns(address[] memory)
    {
        return map_Users[userAddress].DirectAddresses;
    }

    function Deposit(address sponsorAddress, uint packageId, uint amount) external payable
    {
        RegisterInternal(sponsorAddress, packageId, amount);
    }

    function Redeposit(uint packageId, uint amount) external payable
    {
        DepositInternal(packageId, amount);
    }

    function Withdraw(uint amount) external
    {
        address userAddress = msg.sender;
        require(GetTotalIncome(userAddress)-map_UserIncome[userAddress].AmountWithdrawn>=amount, "Insufficient funds!");

        map_UserIncome[userAddress].AmountWithdrawn += amount;

        uint deductionAmount = amount*10/100;
        uint amountWithdrawn = amount-deductionAmount;

        DistributeWithdrawalLevelIncome(userAddress, amount);

        SendTokens(userAddress, amountWithdrawn);
        SendTokens(CreatorAddress, deductionAmount);
    }

}