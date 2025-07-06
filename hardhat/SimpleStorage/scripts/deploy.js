const { ethers, run } = require("hardhat");

const main = async () => {
    const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage");

    console.log("Deploying contract...");
    const simpleStorage = await SimpleStorageFactory.deploy();

    await simpleStorage.waitForDeployment();
    console.log(`Contract deployed to: ${simpleStorage.target}`);
    // Verify the contract on Etherscan but not in the Hardhat network
    console.log("Verifying contract...");
    if (network.config.chainId !== 31337) {
        await simpleStorage.waitForDeployment({ confirmations: 12 }); // Wait ~2.5 minutes on Sepolia
        console.log("Waiting 60 seconds for Etherscan indexing...");
        await new Promise((res) => setTimeout(res, 60000)); // 1 minute delay
        await verify(simpleStorage.target, []);
    } else {
        console.log("Skipping verification on Hardhat network.");
    }

    const currentValue = await simpleStorage.retrieve();
    console.log(`Current value in SimpleStorage: ${currentValue}`);

    const transactionResponse = await simpleStorage.store(42);
    const transactionReceipt = await transactionResponse.wait(1);
    const updatedValue = await simpleStorage.retrieve();
    console.log(`Updated value in SimpleStorage: ${updatedValue}`);

};

const verify = async (contractAddress, args) => {

    console.log("Verifying contract...");
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        });
        console.log("Contract verified successfully!");
    } catch (error) {
        if (error.message.toLowerCase().includes("already verified")) {
            console.log("Contract is already verified.");
        } else {
            console.error("Verification failed:", error);
        }
    }
}

(async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error("Error deploying contract:", error);
        process.exit(1);
    }
})();
