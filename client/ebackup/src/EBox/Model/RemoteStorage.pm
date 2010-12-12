# Copyright (C) 2009-2010 eBox Technologies S.L.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


package EBox::EBackup::Model::RemoteStorage;

# Class: EBox::EBackup::Model::RemoteStorage
#
#   TODO: Document the class
#

use base 'EBox::Model::DataForm::ReadOnly';

use strict;
use warnings;

use EBox::Global;
use EBox::Gettext;
use EBox::Types::Select;
use EBox::Types::Text;

# Group: Public methods

# Constructor: new
#
#       Create the new Hosts model
#
# Overrides:
#
#       <EBox::Model::DataForm::new>
#
# Returns:
#
#       <EBox::EBackup::Model::Hosts> - the recently created model
#
sub new
{
    my $class = shift;

    my $self = $class->SUPER::new(@_);

    bless ( $self, $class );

    return $self;
}


sub _content
{
    my ($self) = @_;
    if (not defined $self->{storage}) {
        my $ebackup = $self->{gconfmodule};
        $self->{storage} = $ebackup->storageUsage();
        if (not defined $self->{storage}) {
            return {
                    used => __('Unknown'),
                    available => __('Unknown'),
                    total     => __('Unknown'),
                   };
        }
    }

    return {
            used => $self->{storage}->{used} . ' MB',
            available => $self->{storage}->{available} . ' MB',
            total => $self->{storage}->{total} . ' MB',
           };
}




# Method: precondition
#
# Overrides:
#
#      <EBox::Model::DataTable::precondition>
#
sub precondition
{
    my ($self) = @_;
    my $ebackup = $self->{gconfmodule};
    $self->{storage} = $ebackup->storageUsage();
    return defined $self->{storage}
}

# Method: preconditionFailMsg
#
# Overrides:
#
#      <EBox::Model::DataTable::preconditionFailMsg>
#
sub preconditionFailMsg
{
    my ($self) = @_;
    # nothing to show if not precondition..
    return '';
}


#
# Group: Protected methods

# Method: _table
#
# Overrides:
#
#      <EBox::Model::DataTable::_table>
#
sub _table
{

    my @tableHeader = (
        new EBox::Types::Text(
            fieldName     => 'used',
            printableName => __('Used storage'),
        ),
        new EBox::Types::Text(
            fieldName     => 'available',
            printableName => __('Available storage'),
        ),
        new EBox::Types::Text(
           fieldName     => 'total',
            printableName => __('Total storage'),
        ),
    );

    my $dataTable =
    {
        tableName          => 'RemoteStorage',
        printableTableName => __('Remote Storage Usage'),
        printableRowName   => __('backup'),
        tableDescription   => \@tableHeader,
        class              => 'dataTable',
        modelDomain        => 'EBackup',
    };

    return $dataTable;

}


1;
