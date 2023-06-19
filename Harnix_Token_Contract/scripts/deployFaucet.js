// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {

    const Faucet = await ethers.getContractFactory("Faucet");
    const faucet = await Faucet.deploy("0x287D11dfBc5463B2666709f30fD15dA53B307c2a");
    faucet.deployed();
    console.log(`Faucet Contract Deployed: ${faucet.address}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
