## Development
This page outlines the steps to making changes to the code base.
____

### Release Process
The following outlines the steps for releasing a version.
 
#### Step A
1. When the develop branch has the features, changes as decided a draft of a release tag should be begun: [releases page](https://github.com/litecoin-foundation/loafwallet-ios/releases)

2. From the develop branch, a new branch needs to be created in the semver method (v#.#.#) e.g.; `release/v2.9.0`

3. Final testing and changes are committed to the branch. When ready, a build is created and sent to the App Store. The build should been set to the TestFlight and encourage testers....wait.

4. Once the build is approved, a PR to merge the `release/v2.9.0` into `master` is pushed to Github.

5. Once approved, it's merged.
   

#### Step B
6. A new PR from the `release/v2.9.0` to `develop` is created

7. The resolution of conflicts is completed

8. Once approved, it's merged.



 
--- 