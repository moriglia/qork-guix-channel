# Qork Channel for the Guix package manager

Just some packages that I needed and were not available...

## Add this cannel

```scm
(cons 
	(channel
		(name 'qork-guix-channel)
		(url "https://github.com/moriglia/qork-guix-channel.git")
		(branch "main"))
	%default-channels)
```
