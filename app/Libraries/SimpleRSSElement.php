<?php

declare(strict_types=1);

/**
 * @copyright  2021 Podlibre
 * @license    https://www.gnu.org/licenses/agpl-3.0.en.html AGPL3
 * @link       https://castopod.org/
 */

namespace App\Libraries;

use SimpleXMLElement;

class SimpleRSSElement extends SimpleXMLElement
{
    /**
     * Adds a child with $value inside CDATA
     *
     * @param string $name — The name of the child element to add.
     * @param string $value — [optional] If specified, the value of the child element.
     * @param string|null $namespace [optional] If specified, the namespace to which the child element belongs.
     *
     * @return static The addChild method returns a SimpleXMLElement object representing the child added to the XML node.
     */
    public function addChildWithCDATA(string $name, string $value = '', ?string $namespace = null)
    {
        $newChild = parent::addChild($name, '', $namespace);

        if ($newChild !== null) {
            $node = dom_import_simplexml($newChild);
            if ($node !== null) {
                $no = $node->ownerDocument;
                if ($no !== null) {
                    $node->appendChild($no->createCDATASection($value));
                }
            }
        }

        return $newChild;
    }

    /**
     * Adds a child element to the XML node with escaped $value if specified. Override of addChild method as
     * SimpleXMLElement's addChild method doesn't escape ampersand
     *
     * @param string $name — The name of the child element to add.
     * @param string $value — [optional] If specified, the value of the child element.
     * @param string $namespace [optional] If specified, the namespace to which the child element belongs.
     * @param boolean $escape [optional] The value is escaped by default, can be set to false.
     *
     * @return static The addChild method returns a SimpleXMLElement object representing the child added to the XML node.
     */
    public function addChild($name, $value = null, $namespace = null, $escape = true)
    {
        $newChild = parent::addChild($name, '', $namespace);

        if ($newChild !== null) {
            $node = dom_import_simplexml($newChild);
            if ($node !== null) {
                $no = $node->ownerDocument;
                $value = $escape ? esc($value ?? '') : $value ?? '';
                if ($no === null) {
                    return $newChild;
                }
                if (is_array($value)) {
                    return $newChild;
                }
                /** @noRector RecastingRemovalRector */
                $node->appendChild($no->createTextNode((string) $value));
                return $newChild;
            }
        }

        return $newChild;
    }
}
