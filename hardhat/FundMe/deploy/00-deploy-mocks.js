module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const { network } = require("hardhat");
    const { developmentChains, DECIMALS, INITIAL_ANSWER } = require("../helper-hardhat-config");

    if (developmentChains.includes(network.name)) {
        log("Local network detected! Deploying mocks...");
        // Deploy a mock price feed
        await deployments.deploy("MockV3Aggregator", {
            from: deployer,
            log: true,
            args: [DECIMALS, INITIAL_ANSWER], // 8 decimals, $20.00
        });
        log("Mocks deployed!");
        log("------------------------------------------------");
    }


}


module.exports.tags = ["all", "mocks"];