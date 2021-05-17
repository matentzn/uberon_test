LAST_RELEASE=http://svn.code.sf.net/p/obo/svn/uberon/releases/2020-09-16/
ODK_BRANCH=https://raw.githubusercontent.com/obophenotype/uberon/odk-upgrade/
ROBOT=robot

DIFFS=uberon.owl composite-metazoan.owl subset-euarchontoglires-basic.owl subset-human-view.owl

subset-%-last-release.owl:
	wget $(LAST_RELEASE)subsets/$* -O $@

%-last-release.owl:
	wget $(LAST_RELEASE)$* -O $@

subset-%-odk-branch.owl:
	wget $(ODK_BRANCH)subsets/$* -O $@

subset-composite-metazoan.owl-odk-branch.owl:
	wget https://www.dropbox.com/s/poa7n2kcpkiidqs/composite-metazoan.owl?dl=0 -O $@

%-odk-branch.owl:
	wget $(ODK_BRANCH)$* -O $@
.PRECIOUS: %.owl

robot-diff-%.txt: %-last-release.owl %-odk-branch.owl
	$(ROBOT) diff --left $< --right $*-odk-branch.owl -o $@

.PHONY: diff
diff: $(patsubst %,robot-diff-%.txt,$(DIFFS))
