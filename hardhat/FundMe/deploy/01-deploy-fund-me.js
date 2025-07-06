//Hardhat deploy

const { networkConfig, developmentChains } = require("../helper-hardhat-config");
const { network } = require("hardhat");
const { verify } = require("../utils/verify")
require("dotenv").config()


module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;

    let ethUsdPriceFeedAddress;

    if (developmentChains.includes(network.name)) {
        // If we are on a local network, we deploy a mock price feed
        const ethUsdAggregator = await deployments.get("MockV3Aggregator");
        ethUsdPriceFeedAddress = ethUsdAggregator.address;
        log("Using MockV3Aggregator as price feed");
    } else {
        // If we are on a testnet or mainnet, we use the real price feed address
        ethUsdPriceFeedAddress = networkConfig[chainId]?.ethUsdPriceFeed;
        if (!ethUsdPriceFeedAddress) {
            throw new Error(`No ETH/USD price feed address found for chain ID ${chainId}`);
        }
    }

    // const ethUsdPriceFeedAddress = networkConfig[chainId]?.ethUsdPriceFeed;


    // If we are on a local network, we don't need to deploy the mock
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [ethUsdPriceFeedAddress], // constructor arguments
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    });

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fundMe.address, [ethUsdPriceFeedAddress])
    }



    log(`FundMe deployed at ${fundMe.address} by ${deployer}`);
    log("------------------------------------------------");
}

module.exports.tags = ["all", "fundme"];