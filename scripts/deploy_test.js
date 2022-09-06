const main = async () => {
    try {
      const nftContractFactory = await hre.ethers.getContractFactory(
        "ChainBattles"
      );
      const nftContract = await nftContractFactory.deploy();
      await nftContract.deployed();
  
      console.log("Contract deployed to:", nftContract.address);

      const [owner] = await hre.ethers.getSigners();

      await nftContract.connect(owner).mint();

      var level = await nftContract.connect(owner).getLevels(1);
      var speed = await nftContract.connect(owner).getSpeed(1);
      var strength = await nftContract.connect(owner).getStrength(1);
      var life = await nftContract.connect(owner).getLife(1);

      console.log("Statistics: "  + level + speed + strength + life);

      await nftContract.connect(owner).train(1);
      await nftContract.connect(owner).train(1);
      await nftContract.connect(owner).train(1);
      await nftContract.connect(owner).train(1);
      await nftContract.connect(owner).train(1);
      await nftContract.connect(owner).train(1);

      level = await nftContract.connect(owner).getLevels(1);
      speed = await nftContract.connect(owner).getSpeed(1);
      strength = await nftContract.connect(owner).getStrength(1);
      life = await nftContract.connect(owner).getLife(1);

      console.log("Statistics: "  + level + speed + strength + life);


      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
    
  main();