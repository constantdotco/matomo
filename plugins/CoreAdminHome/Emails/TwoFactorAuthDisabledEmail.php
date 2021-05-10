<?php
/**
 * Matomo - free/libre analytics platform
 *
 * @link https://matomo.org
 * @license http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 *
 */

namespace Piwik\Plugins\CoreAdminHome\Emails;

use Piwik\Piwik;

class TwoFactorAuthDisabledEmail extends SecurityNotificationEmail
{
    protected function getBody()
    {
        return Piwik::translate('CoreAdminHome_SecurityNotificationTwoFactorAuthDisabledBody');
    }
}
