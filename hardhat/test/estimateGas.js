const { ethers } = require("hardhat");

describe("Gas Usage - BBD Contract", function () {
    this.timeout(1800000);
    it("Estimates gas for 100 users", async function () {
        const [deployer] = await ethers.getSigners();

        // 1. Deploy mock token
        const Token = await ethers.getContractFactory("USDTToken");
        const token = await Token.deploy();
        await token.waitForDeployment();

        // 2. Deploy BBD contract
        const BBD = await ethers.getContractFactory("BBD");
        const bbd = await BBD.deploy(token.target); // Use token address in constructor
        await bbd.waitForDeployment();

        // 3. Deploy SecurityFund contract
        const SecurityFund = await ethers.getContractFactory("BBD_SecurityFundContract");
        const security = await SecurityFund.deploy();
        await security.waitForDeployment();

        // 4. Link BBD ↔ SecurityFund
        const tx1 = await bbd.SetSecurityFundContract(security.target);
        await tx1.wait();

        const tx2 = await security.setMainContract(bbd.target);
        await tx2.wait();


        const users = [];
        const sponsor = "0xA1bF05780C2De3002086695D212a743EAA6532Ad";

        let totalGas = 0n;
        let registerGas = 0n;
        let depositGas = 0n;

        for (let i = 0; i < 100; i++) {
            // Create a new random wallet
            const wallet = ethers.Wallet.createRandom().connect(ethers.provider);
            users.push(wallet);

            // Fund wallet with native tokens for gas
            await deployer.sendTransaction({
                to: wallet.address,
                value: ethers.parseEther("1"),
            });

            // 1. Register user
            const sponsorAddress = i === 0 ? sponsor : users[i - 1].address;
            const regTx = await bbd.connect(wallet).Register(sponsorAddress, 1, 0);
            const regReceipt = await regTx.wait();
            registerGas = registerGas < regReceipt.gasUsed ? regReceipt.gasUsed : registerGas;
            totalGas += regReceipt.gasUsed;

            // 2. Mint 3000 USDT to the user
            const usdtAmount = ethers.parseUnits("3000", 18);
            await token.transfer(wallet.address, usdtAmount);

            // 3. Approve BBD contract to spend USDT
            await token.connect(wallet).approve(bbd.target, usdtAmount);

            // 4. Call Deposit
            const depositTx = await bbd.connect(wallet).Deposit(1, usdtAmount);
            const depositReceipt = await depositTx.wait();

            depositGas = depositGas < depositReceipt.gasUsed ? depositReceipt.gasUsed : depositGas;
            totalGas += depositReceipt.gasUsed;
        }


        // 5. Simulate user registration (gas usage test)
        // let totalGas = 0n;

        // for (let i = 0; i < 50; i++) {
        //   const wallet = ethers.Wallet.createRandom().connect(ethers.provider);
        //   await deployer.sendTransaction({
        //     to: wallet.address,
        //     value: ethers.parseEther("1"),
        //   });

        //   const tx = await bbd.connect(wallet).Register("0xA1bF05780C2De3002086695D212a743EAA6532Ad", 1, 0); // or appropriate method
        //   const receipt = await tx.wait();
        //   totalGas += receipt.gasUsed;
        // }
        console.log("Max register gas: ", registerGas);
        console.log("Max deposit gas: ", depositGas);

        const gasPriceGwei = 3n;
        const gasPriceWei = gasPriceGwei * 1_000_000_000n;
        const totalDepositCostWei = depositGas * gasPriceWei;
        const depositCostEth = ethers.formatEther(totalDepositCostWei);
        
        const totalRegisterCostWei = registerGas * gasPriceWei;
        const registerCostEth = ethers.formatEther(totalRegisterCostWei);
        

        console.log(`💰 Register Cost @ 3 Gwei: ${registerCostEth} BNB`);
        console.log(`💰 Deposit Cost @ 3 Gwei: ${depositCostEth} BNB`);

        // console.log(`\n✅ Total Gas Used for 50 users: ${totalGas}`);
        console.log(`⛽ Average Gas Per User: ${totalGas / 50n}`);
    });
});
