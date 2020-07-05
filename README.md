hibp
=====

Have I Been Pwned "Pwned Passwords" client.


Summary
-------

hibp provides one function `hibp:check_password/1` which returns `ok`
or `not_ok` based on the results of an HIBP API search.  The supplied
password may be either a list or a binary.

Example
-------

``` erlang

1> application:ensure_started(hibp).
ok

2> hibp:check_password("123456").
not_ok

3> hibp:check_password(<<"tCHRL43TRQX@">>).
ok

```

Further Reading
---------------

[HIBP API v3 Documentation](https://haveibeenpwned.com/API/v3#PwnedPasswords)
[HIBP Methodology](https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/)


Credits
-------

I've incorporated the Public Domain library sha1-erlang into this
package.  The credits for that packe read:

``` erlang
%%% SHA-1 module
%%% Author: Nicolas Favre-Felix - n.favrefelix@gmail.com
%%% License: Public Domain
%%% Original page: http://github.com/nicolasff/sha1-erlang/
```

Many thanks to Mr. Favre-Felix.

