-module(hibp).
-export([ 
          check_password/1
        ]).

-define(HIBP_URL, "https://api.pwnedpasswords.com/range/").


%% @doc Check password against Have I Been Pwned database.
%%
%% Returns 'ok' if password does not appear and 'not_ok' if it does.  
%%
%% Please see https://haveibeenpwned.com/API/v3#PwnedPasswords and
%% https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/
%% for further information.
-spec check_password(PW :: string() | binary()) -> ok | not_ok.
check_password(PW) ->
  HashedPW = hash_password(PW),
  hibp(HashedPW).



%%% Internal Functions.

%% Create SHA1 hash of binary or string password.
hash_password(PW) when is_binary(PW) ->
  hash_password(binary_to_list(PW));
hash_password(PW) ->
  sha1:hexstring(PW).

%% Call the HIBP_URL with the hashed password and parse the response.
hibp(HashedPW) ->
  check_response(HashedPW, hackney:get(url(HashedPW), [], <<>>, [])).

%% Check HTTPS response: if okay, parse results; if not, raise error.
check_response(HashedPW, {ok, 200, _, Ref}) ->
  case hackney:body(Ref) of
    {ok, <<>>} -> ok;
    {ok, Body} -> check_response_body(HashedPW, Body)
  end;
check_response(_, _) ->
  error(invalid_https_response).

%% Compare the response body with the password suffix, if the suffix
%% isn't found in the results provided by HIBP, return ok; not_ok
%% otherwise.
check_response_body(HashedPW, Body) ->
  case binary:match(Body, list_to_binary(password_suffix(HashedPW))) of
    nomatch -> ok;
    _ -> not_ok
  end.

%% Create the HIBP URL (base URL + first five characters of hash).
url(HashedPW) ->
  ?HIBP_URL ++ password_sig(HashedPW).

password_sig(HashedPW) ->
  string:sub_string(HashedPW, 1, 5).

password_suffix(HashedPW) ->
  string:sub_string(HashedPW, 6).
