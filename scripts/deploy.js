const hre = require("hardhat");

async function main() {
  const ETHUSDPrice = await hre.ethers.getContractFactory("ETHUSDPrice");
  const ethUsdPrice = await ETHUSDPrice.deploy();
  await ethUsdPrice.deployed();
  console.log("ethUsdPrice deployed to: ", ethUsdPrice.address);

  const USDCUSDPrice = await hre.ethers.getContractFactory("USDCUSDPrice");
  const usdcUsdPrice = await USDCUSDPrice.deploy();
  await usdcUsdPrice.deployed();
  console.log("usdcUsdPrice deployed to: ", usdcUsdPrice.address);

  const SYLIUMOracle = await hre.ethers.getContractFactory("SYLIUMOracle");
  const syliumOracle = await SYLIUMOracle.deploy();
  await syliumOracle.deployed();
  console.log("SYLIUMOracle deployed to: ", syliumOracle.address);

  const Aquafina = await hre.ethers.getContractFactory("Aquafina");
  const aquafina = await Aquafina.deploy(1650456000, 10);
  await aquafina.deployed();
  console.log("Aquafina deployed to: ", aquafina.address);

  const syETH = await hre.ethers.getContractFactory("syETH");
  const syEth = await syETH.deploy();
  await syEth.deployed();
  console.log("syEth deployed to: ", syEth.address);

  const syUSDC = await hre.ethers.getContractFactory("syUSDC");
  const syUsdc = await syUSDC.deploy();
  await syUsdc.deployed();
  console.log("syUsdc deployed to: ", syUsdc.address);

  const SYLIX = await hre.ethers.getContractFactory("SYLIX");
  const sylix = await SYLIX.deploy();
  await sylix.deployed();
  console.log("sylix deployed to: ", sylix.address);

  const SYLIUM = await hre.ethers.getContractFactory("SYLI");
  const sylium = await SYLIUM.deploy();
  await sylium.deployed();
  console.log("sylium deployed to: ", sylium.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
