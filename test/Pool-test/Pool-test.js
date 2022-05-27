const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");
const ERC20ABI = require("./ERC20.json");

const usdcAddress = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const ethAddress = "0x64FF637fB478863B7468bc97D30a5bF3A428a1fD";

describe("SYLIUMPool", function () {
  let syEth;
  let syUsdc;
  let sylix;
  let syliumPool;

  beforeEach(async () => {
    // ADDRESSES OF THE DEPLOYED CONTRACTS
    const syETHAddress = "0x71089Ba41e478702e1904692385Be3972B2cBf9e";
    const syUSDCAddress = "0x8F4ec854Dd12F1fe79500a1f53D0cbB30f9b6134";
    const sylixAddress = "0xC66AB83418C20A65C3f8e83B3d11c8C3a6097b6F";
    const syliumAddress = "0xeF31027350Be2c7439C1b0BE022d49421488b72C";
    // INSTANCES OF CONTRACTS NEEDED
    const syETH = await ethers.getContractFactory("syETH");
    const syUSDC = await ethers.getContractFactory("syUSDC");
    const SYLIX = await ethers.getContractFactory("SYLIX");
    const SyliumPool = await ethers.getContractFactory("SYLIUMPool");

    // ATTACH
    syEth = await syETH.attach(syETHAddress);
    syUsdc = await syUSDC.attach(syUSDCAddress);
    sylix = await SYLIX.attach(syliumAddress);

    // DEPLOYMENT
    syliumPool = await SyliumPool.deploy(2);
    await syliumPool.deployed();

    /*syEth = await syETH.deploy();
    await syEth.deployed();

    syUsdc = await syUSDC.deploy();
    await syUsdc.deployed();

    sylix = await SYLIX.deploy();
    await sylix.deployed();*/
  });

  it("Should return the information for the SYLIUM Minting", async function () {
    console.log(
      "========== GETTING THE NUM NEEDED FOR EACH TOKEN TO MINT ONE SYLIUM =========="
    );
    let pEth,
      pUsdc,
      pSylix = await syliumPool.getSyliumInCollateral();
    console.log(pEth, pUsdc, pSylix);
  });

  it("Should simulate a SYLIUM minting and and SYLIUM redeeming", async function () {
    // GETTING THE SIGNERS
    const [governance, receiver] = await ethers.getSigners();

    const amount = 100;
    const PRECISION = 1e13;
    const tokenAmount = BigNumber.from("1000000000000000000000000000000000000");

    console.log("========== GETTING MOCKTOKENS FOR THE GOVERNANCE ==========");
    await syEth.mint_syETH(governance.address, tokenAmount);
    await syUsdc.mint_syUSDC(governance.address, tokenAmount);
    await sylix.mint_sylix(governance.address, tokenAmount);

    let govEthBalance = await syEth.balanceOf(governance.address);
    let govUsdcBalance = await syUsdc.balanceOf(governance.address);
    let govSylixBalance = await sylix.balanceOf(governance.address);

    console.log("Governance ETH Balance: " + govEthBalance);
    console.log("Governance USDC Balance: " + govUsdcBalance);
    console.log("Governance SYLIX Balance: " + govSylixBalance);

    console.log("========== GETTING MOCKTOKEN FOR THE RECEIVER ==========");
    await syEth.mint_syETH(receiver.address, tokenAmount);
    await syUsdc.mint_syUSDC(receiver.address, tokenAmount);
    await sylix.mint_sylix(receiver.address, tokenAmount);

    let receiverEthBalance = await syEth.balanceOf(receiver.address);
    let receiverUsdcBalance = await syUsdc.balanceOf(receiver.address);
    let receiverSylixBalance = await sylix.balanceOf(receiver.address);

    console.log("Receiver ETH Balance: " + receiverEthBalance);
    console.log("Receiver USDC Balance: " + receiverUsdcBalance);
    console.log("Receiver SYLIX Balance: " + receiverSylixBalance);

    console.log("========== nETH, nUSDC & nSYLIX ==========");
    let nEth,
      nUsdc,
      nSylix = await syliumPool.getSyliumInCollateral();
    console.log(nEth, nUsdc, nSylix);

    console.log("========== RECEIVER MINT SYLIUM ==========");
    await syEth.connect(receiver).approve(syliumPool.address, tokenAmount);
    await syUsdc.connect(receiver).approve(syliumPool.address, tokenAmount);
    await sylix.connect(receiver).approve(syliumPool.address, tokenAmount);
    await syliumPool.connect(receiver).mintSylium(1);
  });
});

// https://stackoverflow.com/questions/71190549/owner-account-start-with-a-non-zero-dai-balance-in-hardhat-test-suite
// https://stackoverflow.com/questions/71190549/owner-account-start-with-a-non-zero-dai-balance-in-hardhat-test-suite
// https://medium.com/coinmonks/yield-farming-tutorial-part-2-ea5b5254805d
// https://kndrck.co/posts/local_erc20_bal_mani_w_hh/
// https://www.quicknode.com/guides/web3-sdks/how-to-connect-to-ethereum-network-with-ethers-js
// https://www.quicknode.com/guides/web3-sdks/how-to-connect-to-ethereum-network-with-ethers-js
// https://stackoverflow.com/questions/67177659/testing-error-for-function-call-to-a-non-contract-account
// https://docs.ethers.io/v5/api/utils/bignumber/
// https://ethereum.stackexchange.com/questions/95023/hardhat-how-to-interact-with-a-deployed-contract
// https://docs.openzeppelin.com/learn/deploying-and-interacting#interacting-from-the-console
// https://ethereum.org/en/developers/tutorials/understand-the-erc-20-token-smart-contract/
// https://ethereum.stackexchange.com/questions/95023/hardhat-how-to-interact-with-a-deployed-contract
