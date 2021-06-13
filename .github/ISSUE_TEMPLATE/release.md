---
name: 🚀[Release] 
about: An issue template to make sure the release process is followed
title: '🚀[Release]'
labels: 'Release'
assignees: 'kcw-grunt'

---

## Goal 
The process of publishing/launching a new release of **Litewallet** should be consistent and drama-free. It should also allow the team to catch errors before they occur. This template should make it easy for any iOS developer in the team to be confident the release meets all our criteria.

## Prepare code
- [ ] 1. Locally create a new branch from `develop` with the pattern `release/v#.#.#` (Third dot should always be 0 unless there are bugfixes or [PATCHes](https://semver.org))
- [ ] 2. Note and write down the changes in the `develop` branch since the last release tag. 
- [ ] 3. Open a draft release at the [litewallet-ios](https://github.com/litecoin-foundation/litewallet-ios/releases) repo targeting the `main` branch and tag with the pattern: **v#.#.#**
- [ ] 4. Set the release title (should be the same v#.#.#) in [litewallet-ios](https://github.com/litecoin-foundation/litewallet-ios/releases) and add the release notes...add some flair 🤩🔥😅🍀
- [ ] 5. Save as Draft **Very important!**
- [ ] 6. Return to the local branch and do a version bump and build number bump. Commit e.g. : `git commit -m 'version bump'`
- [ ] 7. Publish the release branch e.g. : `git push origin release/v#.#.#`
- [ ] 8. Review the Pull Request in Github and make sure the CI/CD tests and checks pass.  If there are conflicts they need to be resolved and the version needs to be bumped. Return to step 6
- [ ] 9. Ask for code reviews and approvals
--
## Prepare binary
- [ ] 1. In Xcode on the curated release branch, run archive and make sure the .ipa is validated.
- [ ] 2. In Xcode on the curated release branch, distribute the .ipa to the App Store and make sure it uploads completely.
- [ ] 3. Select the binary/build sent from Xcode
--
## Prepare metadata
- [ ] 1. Visit developer.apple.com and set a new version that matches the version set in the release `v#.#.#`
- [ ] 2. Add release notes in the `What's New in This Version` field
- [ ] 3. Add Promotional Text normally `Litewallet is the official Litecoin Wallet from Charlie Lee and the Litecoin Foundation.`
--
## Submit for Testflight
- [ ] 1. Fill test details
- [ ] 2. Select Test Groups
- [ ] 3. Press Submit for review
--
## Submit for review
- [ ] 1. Press Submit for review
- [ ] 2. Wait for `Pending Developer Release` status
--