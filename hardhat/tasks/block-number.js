const { task } = require("hardhat/config");

task("block-number", "Prints the current block number").setAction(
    async (taskArgs, hre) => {
        try {
            const blockNumber = await hre.ethers.provider.getBlockNumber();
            console.log(`Current block number: ${blockNumber}`);
        } catch (error) {
            console.error("Error fetching block number:", error);
        }
    }
);


module.exports = {};