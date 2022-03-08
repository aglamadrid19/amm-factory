const hre = require('hardhat')

async function main() {
	const accounts = await hre.ethers.getSigners()

	const Factory = await hre.ethers.getContractFactory('UffFactory')
	const factory = await Factory.deploy(accounts[0].address)

	await factory.deployed()
	console.log('Factory deployed to:', factory.address)

	const INIT_CODE_PAIR_HASH = await factory.INIT_CODE_PAIR_HASH()
	console.log('INIT_CODE_PAIR_HASH:', INIT_CODE_PAIR_HASH)

	// await hre.run("verify:verify", {
	// 	address: factory.address,
	// 	constructorArguments: [
	// 		accounts[0].address
	// 	],
	// });
}

async function delay(sec) {
    return new Promise((resolve, reject) => {
        setTimeout(resolve, sec * 1000);
    })
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error)
		process.exit(1)
	})