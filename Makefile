LAST_RELEASE=http://svn.code.sf.net/p/obo/svn/uberon/releases/2020-09-16/
ODK_BRANCH=https://raw.githubusercontent.com/obophenotype/uberon/odk-upgrade/
ROBOT=robot

DIFFS=uberon.owl composite-metazoan.owl subset-euarchontoglires-basic.owl subset-human-view.owl

%.obo: %.owl
	$(ROBOT) convert -i $< -f obo --check false -o $@

subset-%-last-release.owl:
	wget $(LAST_RELEASE)subsets/$* -O $@
.PRECIOUS: subset-%-last-release.owl

%-last-release.owl:
	wget $(LAST_RELEASE)$* -O $@
.PRECIOUS: %-last-release.owl

subset-%-odk-branch.owl:
	wget $(ODK_BRANCH)subsets/$* -O $@
.PRECIOUS: subset-%-odk-branch.owl

%-odk-branch.owl:
	wget $(ODK_BRANCH)$* -O $@
.PRECIOUS: %-odk-branch.owl

composite-metazoan.owl-odk-branch.owl:
	wget https://www.dropbox.com/s/poa7n2kcpkiidqs/composite-metazoan.owl?dl=0 -O $@
.PRECIOUS: composite-metazoan.owl-odk-branch.owl

robot-diff-%.txt: %-last-release.owl %-odk-branch.owl
	$(ROBOT) diff --left $< --right $*-odk-branch.owl -o $@
	
obo-simple-diff-%.txt: %-last-release.obo %-odk-branch.obo
	perl obo-simple-diff.pl -l $*-last-release.obo $*-odk-branch.obo > $@

.PHONY: diff
diff: $(patsubst %,robot-diff-%.txt,$(DIFFS)) $(patsubst %,obo-simple-diff-%.txt,$(DIFFS))
