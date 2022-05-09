const { ethers } = require("hardhat");

describe("SYLIX", async function () {
  let sylix;

  beforeEach(async () => {
    const SYLIX = await ethers.getContractFactory("SYLIX");
    sylix = await SYLIX.deploy();
    await sylix.deployed();
  });

  it("Should execute the minting and burning of SyliumShare", async function () {
    const [governance, receiver] = await ethers.getSigners();

    console.log("========== MINTING SYLIX ==========");
    await sylix.mint_sylix(receiver.address, 100);
    let receiverBalance = await sylix.balanceOf(receiver.address);
    console.log(receiverBalance);

    console.log("========== BURNING SYLIX ==========");
    await sylix.connect(receiver).approve(governance.address, 50);
    await sylix.burn_sylix(receiver.address, 30);
    let updatedBalance = await sylix.balanceOf(receiver.address);
    console.log(updatedBalance);
  });
});
