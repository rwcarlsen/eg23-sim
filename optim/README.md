

eg23 optimization
=====================

I've been using a separate branch in github.com/rwcarlsen/cloudlus that has a
modified objective function that is simply energy produced by thermal reactors
divided by enery produced by fast reactors.  the power constraint curve was
generated using power-constr.sh with ``12`` as the argument for annual
deployments - this outputs MinPower and MaxPower json arrays that can be used
in the cloudlus optimization scenario json file.  ``scenario.json`` and
``recycle-tmpl.xml`` are also used in the optimization.  Runs 3 and 5 contain
input and output data from 2 simulation runs with slightly tweaked parameters
(i.e. gradually finding/fixing incorrect simulation setup).

