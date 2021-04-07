<?php

/**
 * This file is based on the HttpSignature file from the ActivityPhp package.
 * It is adapted to work with CodeIgniter4
 *
 * More info: https://github.com/landrok/activitypub
 *
 * @copyright  2021 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

namespace ActivityPub;

use CodeIgniter\HTTP\IncomingRequest;
use CodeIgniter\I18n\Time;
use Config\Services;
use Exception;
use phpseclib\Crypt\RSA;

/**
 * HTTP signatures tool
 */
class HttpSignature
{
    const SIGNATURE_PATTERN = '/^
        keyId="(?P<keyId>
            (https?:\/\/[\w\-\.]+[\w]+)
            (:[\d]+)?
            ([\w\-\.#\/@]+)
        )",
        algorithm="(?P<algorithm>[\w\-]+)",
        (headers="\(request-target\) (?P<headers>[\w\-\s]+)",)?
        signature="(?P<signature>[\w+\/]+={0,2})"
    /x';

    /**
     * @var \CodeIgniter\HTTP\IncomingRequest
     */
    protected $request;

    /**
     * @param \CodeIgniter\HTTP\IncomingRequest $request
     */
    public function __construct(IncomingRequest $request = null)
    {
        if (is_null($request)) {
            $request = Services::request();
        }

        $this->request = $request;
    }

    /**
     * Verify an incoming message based upon its HTTP signature
     *
     * @return bool True if signature has been verified. Otherwise false
     */
    public function verify()
    {
        if (!($dateHeader = $this->request->header('date'))) {
            throw new Exception('Request must include a date header.');
        }

        // verify that request has been made within the last hour
        $currentTime = Time::now();
        $requestTime = Time::createFromFormat(
            'D, d M Y H:i:s T',
            $dateHeader->getValue(),
        );

        $diff = $requestTime->difference($currentTime);
        if ($diff->getSeconds() > 3600) {
            throw new Exception('Request must be made within the last hour.');
        }

        // check that digest header is set
        if (!($digestHeader = $this->request->header('digest'))) {
            throw new Exception('Request must include a digest header');
        }
        // compute body digest and compare with header digest
        $bodyDigest = hash('sha256', $this->request->getBody(), true);
        $digest = 'SHA-256=' . base64_encode($bodyDigest);
        if ($digest !== $digestHeader->getValue()) {
            throw new Exception('Request digest is incorrect.');
        }

        // read the Signature header
        if (!($signature = $this->request->getHeaderLine('signature'))) {
            // Signature header not found
            throw new Exception('Request must include a signature header');
        }

        // Split it into its parts (keyId, headers and signature)
        if (!($parts = $this->splitSignature($signature))) {
            throw new Exception('Malformed signature string.');
        }

        // extract parts as $keyId, $headers and $signature variables
        extract($parts);

        // Fetch the public key linked from keyId
        $actorRequest = new ActivityRequest($keyId);
        $actorResponse = $actorRequest->get();
        $actor = json_decode($actorResponse->getBody());

        $publicKeyPem = $actor->publicKey->publicKeyPem;

        // Create a comparison string from the plaintext headers we got
        // in the same order as was given in the signature header,
        $data = $this->getPlainText(explode(' ', trim($headers)));

        // Verify that string using the public key and the original signature.
        $rsa = new RSA();
        $rsa->setHash('sha256');
        $rsa->setSignatureMode(RSA::SIGNATURE_PKCS1);
        $rsa->loadKey($publicKeyPem);

        return $rsa->verify($data, base64_decode($signature, true));
    }

    /**
     * Split HTTP signature into its parts (keyId, headers and signature)
     *
     * @param string $signature
     * @return bool|array
     */
    private function splitSignature(string $signature)
    {
        if (!preg_match(self::SIGNATURE_PATTERN, $signature, $matches)) {
            // Signature pattern failed
            return false;
        }

        // Headers are optional
        if (!isset($matches['headers']) || $matches['headers'] == '') {
            $matches['headers'] = 'date';
        }

        return $matches;
    }

    /**
     * Get plain text that has been originally signed
     *
     * @param  array $headers HTTP header keys
     * @return string
     */
    private function getPlainText(array $headers)
    {
        $strings = [];
        $strings[] = sprintf(
            '(request-target): %s %s%s',
            $this->request->getMethod(),
            '/' . $this->request->uri->getPath(),
            $this->request->uri->getQuery()
                ? '?' . $this->request->uri->getQuery()
                : '',
        );

        foreach ($headers as $key) {
            if ($this->request->hasHeader($key)) {
                $strings[] = "$key: {$this->request->getHeaderLine($key)}";
            }
        }

        return implode("\n", $strings);
    }
}