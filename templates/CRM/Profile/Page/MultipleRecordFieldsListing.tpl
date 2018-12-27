{*
 +--------------------------------------------------------------------+
 | CiviCRM version 5                                                  |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2018                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*}
{if $showListing}
  {if $dontShowTitle neq 1}<h1>{ts}{$customGroupTitle}{/ts}</h1>{/if}
  {if $pageViewType eq 'customDataView'}
     {assign var='dialogId' value='custom-record-dialog'}
  {else}
     {assign var='dialogId' value='profile-dialog'}
     <div id="multirecordfieldlist-through-profile"></div>
  {/if}
  {if $headers or ($pageViewType eq 'customDataView')}
    {include file="CRM/common/jsortable.tpl"}
    <div id="custom-{$customGroupId}-table-wrapper" {if $pageViewType eq 'customDataView'}class="crm-entity" data-entity="contact" data-id="{$contactId}"{/if}>
      <div>
        {if $pageViewType eq 'customDataView'}
          {strip}
          <table id="records-{$customGroupId}" class={if $pageViewType eq 'customDataView'}"crm-multifield-selector crm-ajax-table"{else}'display'{/if}>
            <thead>
              {foreach from=$headers key=recId item=head}
                <th data-data={ts}'{$headerAttr.$recId.columnName}'{/ts}
                {if !empty($headerAttr.$recId.dataType)}cell-data-type="{$headerAttr.$recId.dataType}"{/if}
                {if !empty($headerAttr.$recId.dataEmptyOption)}cell-data-empty-option="{$headerAttr.$recId.dataEmptyOption}"{/if}>{ts}{$head}{/ts}
                </th>
              {/foreach}
              <th data-data="action" data-orderable="false">&nbsp;</th>
            </thead>
              {literal}
              <script type="text/javascript">
                (function($) {
                  var ZeroRecordText = {/literal}'{ts 1=$customGroupTitle|escape}No records of type \'%1\' found.{/ts}'{literal};
                  var $table = $('#records-' + {/literal}'{$customGroupId}'{literal});
                  $('table.crm-multifield-selector').data({
                    "ajax": {
                      "url": {/literal}'{crmURL p="civicrm/ajax/multirecordfieldlist" h=0 q="snippet=4&cid=$contactId&cgid=$customGroupId&profile_id=$profileId"}'{literal},
                    },
                    "language": {
                      "emptyTable": ZeroRecordText,
                    },
                    //Add class attributes to cells
                    "rowCallback": function(row, data) {
                      $('thead th', $table).each(function(index) {
                        var fName = $(this).attr('data-data');
                        var cell = $('td:eq(' + index + ')', row);
                        if (typeof data[fName] == 'object') {
                          if (typeof data[fName].data != 'undefined') {
                            $(cell).html(data[fName].data);
                          }
                          if (typeof data[fName].cellClass != 'undefined') {
                            $(cell).attr('class', data[fName].cellClass);
                          }
                        }
                      });
                    }
                  })
                })(CRM.$);
              </script>
              {/literal}
          </table>
          {/strip}
        {else}
          {literal}
          <script type="text/javascript">
            CRM.$(function($) {
              CRM.loadPage(
                CRM.url(
                  'civicrm/contact/view/cd',
                  {
                    reset: 1,
                    cid: {/literal}{$contactId}{literal},
                    gid: {/literal}{$customGroupId}{literal},
                    profile_id: {/literal}{$profileId}{literal},
                  },
                  'back'
                ),
                {
                  target : '#multirecordfieldlist-through-profile',
                  dialog : false
                }
              );
            });
          </script>
          {/literal}
        {/if}
      </div>
    </div>
    <div id='{$dialogId}' class="hiddenElement"></div>
  {elseif !$headers}
    <div class="messages status no-popup">
      <div class="icon inform-icon"></div>
      &nbsp;
      {ts 1=$customGroupTitle}No records of type '%1' found.{/ts}
    </div>
    <div id='{$dialogId}' class="hiddenElement"></div>
  {/if}

  {if !$reachedMax}
    {if $pageViewType eq 'customDataView'}
      <div class="action-link">
        {if $profileId}
          <a accesskey="N" href="{crmURL p='civicrm/profile/edit' q="reset=1&id=`$contactId`&multiRecord=add&gid=`$profileId`&context=multiProfileDialog&onPopupClose=`$onPopupClose`"}"
           class="button action-item"><span><i class="crm-i fa-plus-circle"></i> {ts 1=$customGroupTitle}Add New %1 Record{/ts}</span></a>
        {else}
          <br/><a accesskey="N" title="{ts 1=$customGroupTitle}Add %1 Record{/ts}" href="{crmURL p='civicrm/contact/view/cd/edit' q="reset=1&type=$ctype&groupID=$customGroupId&entityID=$contactId&cgcount=$newCgCount&multiRecordDisplay=single&mode=add"}"
           class="button action-item"><span><i class="crm-i fa-plus-circle"></i> {ts 1=$customGroupTitle}Add %1 Record{/ts}</span></a>
        {/if}
      </div>
    {/if}
    <br />
  {/if}
{/if}
