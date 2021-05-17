LAST_RELEASE=http://svn.code.sf.net/p/obo/svn/uberon/releases/2020-09-16/
ODK_BRANCH=https://raw.githubusercontent.com/obophenotype/uberon/odk-upgrade/

subset-%-last-release.owl:
	wget $(LAST_RELEASE)subsets/$* -O $@

%-last-release.owl:
	wget $(LAST_RELEASE)$* -O $@

subset-%-odk-branch.owl:
	wget $(ODK_BRANCH)subsets/$* -O $@

%-odk-branch.owl:
	wget $(ODK_BRANCH)$* -O $@

.PRECIOUS: %.owl

diff-%.txt: %-last-release.owl %-odk-branch.owl
	$(ROBOT) diff --left $< --right $*-odk-branch.owl -o $@

DIFFS=uberon.owl composite-metazoan.owl subset-euarchontoglires-basic.owl subset-human-view.owl

.PHONY: diff
diff: $(patsubst %,diff-%.txt,$(DIFFS))
