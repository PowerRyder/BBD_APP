const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("🚀 Deploying contracts with:", deployer.address);

  // 1. Deploy mock USDT Token
  // const TokenFactory = await hre.ethers.getContractFactory("USDTToken");
  // const token = await TokenFactory.deploy();
  // await token.waitForDeployment();
  // console.log("🪙 USDTToken deployed at:", token.target);

  // 2. Prepare BBD raw deployment tx
  const BBDFactory = await hre.ethers.getContractFactory("BBD");
  // console.log(BBDFactory)
  const deployTx = await BBDFactory.getDeployTransaction(); // token address in constructor
  // console.log(deployTx)
  const tx = await deployer.sendTransaction({
    data: deployTx.data,
    gasLimit: 20_000_000 // try increasing if it fails
  });

  console.log("⏳ Sending raw deploy tx for BBD:", tx.hash);
  const receipt = await tx.wait();
  const bbdAddress = receipt.contractAddress;
  console.log("🏗️  BBD deployed at:", bbdAddress);

  // 3. Deploy SecurityFundContract
  const SecurityFundFactory = await hre.ethers.getContractFactory("BBD_SecurityFundContract");
  const securityFund = await SecurityFundFactory.deploy();
  await securityFund.waitForDeployment();
  console.log("🛡️ SecurityFund deployed at:", securityFund.target);

  // 4. Set mutual references
  const bbd = await hre.ethers.getContractAt("BBD", bbdAddress);

  const tx1 = await bbd.SetSecurityFundContract(securityFund.target);
  await tx1.wait();
  console.log("🔗 Linked SecurityFund to BBD");

  const tx2 = await securityFund.setMainContract(bbdAddress);
  await tx2.wait();
  console.log("🔗 Linked BBD to SecurityFund");
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});
