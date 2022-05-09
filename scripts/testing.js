const { ethers } = require("hardhat");

// scripts/index.js
async function main() {
  const addressAquafina = "0x26B862f640357268Bd2d9E95bc81553a2Aa81D7E";
  const Aquafina = await ethers.getContractFactory("Aquafina");
  const aquafina = await Aquafina.attach(addressAquafina);

  const addressETH = "0xefAB0Beb0A557E452b398035eA964948c750b2Fd";
  const ETH = await ethers.getContractFactory("ETHUSDPrice");
  await ETH.attach(addressETH);

  const addressUSDC = "0xaca81583840B1bf2dDF6CDe824ada250C1936B4D";
  const USDC = await ethers.getContractFactory("USDCUSDPrice");
  await USDC.attach(addressUSDC);

  const addressOracle = "0x70bDA08DBe07363968e9EE53d899dFE48560605B";
  const Oracle = await ethers.getContractFactory("SYLIUMOracle");
  await Oracle.attach(addressOracle);

  await aquafina.setTimer();

  let starter,
    ethGenesisPrice,
    currentEthPrice,
    usdcGenesisPrice,
    currentUsdcPrice = await aquafina.getUpdates();
  console.log(
    starter,
    ethGenesisPrice,
    currentEthPrice,
    usdcGenesisPrice,
    currentUsdcPrice
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
