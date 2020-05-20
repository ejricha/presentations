# Dependencies
In his book, Craig Scott recommends that:
> If a target uses something from a library, it should always link directly to that library. Even if the library is already a link dependency of something else the target links to, do not rely on an indirect link dependency for something a target uses directly.


I think that so long as you are using `PUBLIC` linking anyway, this is unnecessary, as it can lead to dependency graphs that look like this:
<div id="full">
	<img src="cmake/DepsFull.svg" />
</div>


By trimming the dependencies to only the necessary ones, you end up with a much cleaner graph:
<div id="full">
	<img src="cmake/DepsLess.svg" />
</div>
